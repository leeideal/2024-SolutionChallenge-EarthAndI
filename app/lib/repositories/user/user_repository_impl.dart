import 'package:earth_and_i/apps/factory/local_storage_factory.dart';
import 'package:earth_and_i/apps/factory/remote_storage_factory.dart';
import 'package:earth_and_i/domains/type/e_challenge.dart';
import 'package:earth_and_i/domains/type/e_user_status.dart';
import 'package:earth_and_i/models/follow/follow_state.dart';
import 'package:earth_and_i/models/home/character_state.dart';
import 'package:earth_and_i/models/profile/user_brief_state.dart';
import 'package:earth_and_i/models/setting/alarm_state.dart';
import 'package:earth_and_i/providers/follow/follow_provider.dart';
import 'package:earth_and_i/providers/user/user_local_provider.dart';
import 'package:earth_and_i/providers/user/user_remote_provider.dart';
import 'package:earth_and_i/utilities/functions/notification_util.dart';
import 'package:earth_and_i/utilities/functions/security_util.dart';
import 'package:earth_and_i/utilities/functions/widget_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'user_repository.dart';

class UserRepositoryImpl extends GetxService implements UserRepository {
  late final UserLocalProvider _localProvider;
  late final UserRemoteProvider _remoteProvider;

  late final FollowProvider _followProvider;

  @override
  void onInit() {
    super.onInit();
    _localProvider = LocalStorageFactory.userLocalProvider;
    _remoteProvider = RemoteStorageFactory.userRemoteProvider;

    _followProvider = RemoteStorageFactory.followProvider;
  }

  /* ------------------------------------------------------------ */
  /* --------------------------- Read --------------------------- */
  /* ------------------------------------------------------------ */
  @override
  double readTotalPositiveDeltaCO2() {
    return _localProvider.getTotalPositiveDeltaCO2();
  }

  @override
  double readTotalNegativeDeltaCO2() {
    return _localProvider.getTotalNegativeDeltaCO2();
  }

  @override
  UserBriefState readUserBriefState() {
    return UserBriefState(
      id: _localProvider.getId(),
      nickname: _localProvider.getNickname(),
      followingCount: 0,
      followerCount: 0,
    );
  }

  @override
  NotificationState readNotificationState() {
    return NotificationState(
      isActive: _localProvider.getNotificationActive(),
      hour: _localProvider.getNotificationHour(),
      minute: _localProvider.getNotificationMinute(),
    );
  }

  @override
  EChallenge? readCurrentChallenge() {
    return _localProvider.getCurrentChallenge();
  }

  @override
  CharacterStatsState readCharacterStatsState() {
    return CharacterStatsState(
      isEnvironmentCondition: _localProvider.getTotalPositiveDeltaCO2().abs() >=
          _localProvider.getTotalNegativeDeltaCO2(),
      isHealthCondition: _localProvider.getHealthCondition(),
      isMentalCondition: _localProvider.getMentalCondition(),
      isCashCondition: _localProvider.getCashCondition(),
    );
  }

  /* ------------------------------------------------------------ */
  /* -------------------------- Update -------------------------- */
  /* ------------------------------------------------------------ */
  @override
  Future<void> updateUserNotificationSetting({
    bool? isActive,
    int? hour,
    int? minute,
  }) async {
    // Local
    if (isActive != null) {
      await _localProvider.setNotificationActive(isActive);
    }
    if (hour != null && minute != null) {
      await _localProvider.setNotificationHour(hour);
      await _localProvider.setNotificationMinute(minute);
    }

    // Remote
    if (SecurityUtil.isSignin && isActive != null) {
      await _remoteProvider.setNotificationActive(
        _localProvider.getNotificationActive(),
      );
    }

    await NotificationUtil.setScheduleLocalNotification(
      isActive: _localProvider.getNotificationActive(),
      hour: _localProvider.getNotificationHour(),
      minute: _localProvider.getNotificationMinute(),
    );
  }

  @override
  Future<void> updateUserInformation({
    required bool isSignIn,
  }) async {
    if (!isSignIn) {
      await _remoteProvider.setDeviceToken("");

      await _localProvider.setId("GUEST");
      await _localProvider.setNickname("GUEST");
      return;
    }

    final double savedPositiveDeltaCO2 = _calculateSavedTotalDeltaCO2(
      _localProvider.getTotalPositiveDeltaCO2(),
      await _remoteProvider.getTotalPositiveDeltaCO2(),
    );

    final double savedNegativeDeltaCO2 = _calculateSavedTotalDeltaCO2(
      _localProvider.getTotalNegativeDeltaCO2(),
      await _remoteProvider.getTotalNegativeDeltaCO2(),
    );

    // Remote Update(Trigger Gap Handling)
    int maxRetries = 5;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        await _remoteProvider.setTotalPositiveDeltaCO2(savedPositiveDeltaCO2);
        await _remoteProvider.setTotalNegativeDeltaCO2(savedNegativeDeltaCO2);

        await _remoteProvider
            .setDeviceToken(await FirebaseMessaging.instance.getToken() ?? "");
        await _remoteProvider.setDeviceLanguage(
            Get.deviceLocale?.languageCode == "ko" ? "ko" : "en");

        break;
      } catch (e) {
        retryCount++;

        if (retryCount == maxRetries) {
          rethrow;
        }

        await Future.delayed(const Duration(seconds: 1));
      }
    }

    // Remote -> Local Update
    // System Information
    await _localProvider
        .setNotificationActive(await _remoteProvider.getNotificationActive());

    // User Brief Information
    await _localProvider.setId((await _remoteProvider.getId()).substring(0, 5));
    await _localProvider.setNickname(await _remoteProvider.getNickname());

    // User Detail Information
    await _localProvider.setTotalPositiveDeltaCO2(savedPositiveDeltaCO2);
    await _localProvider.setTotalNegativeDeltaCO2(savedNegativeDeltaCO2);

    // Character Stats
    await _localProvider
        .setHealthCondition(await _remoteProvider.getHealthCondition());
    await _localProvider
        .setMentalCondition(await _remoteProvider.getMentalCondition());
    await _localProvider
        .setCashCondition(await _remoteProvider.getCashCondition());

    // Update Synced
    await _localProvider.setSynced(true);

    WidgetUtil.setInformation(
      positiveDeltaCO2: _localProvider.getTotalPositiveDeltaCO2(),
      negativeDeltaCO2: _localProvider.getTotalNegativeDeltaCO2(),
      isHealthCondition: _localProvider.getHealthCondition(),
      isMentalCondition: _localProvider.getMentalCondition(),
      isCashCondition: _localProvider.getCashCondition(),
    );
  }

  @override
  Future<void> updateTotalPositiveDeltaCO2(
    double changedDeltaCO2,
  ) async {
    // Local
    await _localProvider.setTotalPositiveDeltaCO2(
      _localProvider.getTotalPositiveDeltaCO2() + changedDeltaCO2,
    );

    // Remote
    if (SecurityUtil.isSignin) {
      await _remoteProvider.setTotalPositiveDeltaCO2(
        _localProvider.getTotalPositiveDeltaCO2(),
      );
    }
  }

  @override
  Future<void> updateTotalNegativeDeltaCO2(
    double changedDeltaCO2,
  ) async {
    // Local
    await _localProvider.setTotalNegativeDeltaCO2(
      _localProvider.getTotalNegativeDeltaCO2() + changedDeltaCO2,
    );

    // Remote
    if (SecurityUtil.isSignin) {
      await _remoteProvider.setTotalNegativeDeltaCO2(
        _localProvider.getTotalNegativeDeltaCO2(),
      );
    }
  }

  @override
  Future<void> updateCharacterStats(
    EUserStatus? userStatus,
    bool? isGood,
  ) async {
    // Local
    if (userStatus != null && isGood != null) {
      switch (userStatus) {
        case EUserStatus.health:
          await _localProvider.setHealthCondition(isGood);
        case EUserStatus.mental:
          await _localProvider.setMentalCondition(isGood);
        case EUserStatus.cash:
          await _localProvider.setCashCondition(isGood);
        default:
          throw Exception('Invalid user status');
      }
    }

    // Remote
    if (SecurityUtil.isSignin) {
      if (userStatus != null && isGood != null) {
        switch (userStatus) {
          case EUserStatus.health:
            await _remoteProvider.setHealthCondition(isGood);
          case EUserStatus.mental:
            await _remoteProvider.setMentalCondition(isGood);
          case EUserStatus.cash:
            await _remoteProvider.setCashCondition(isGood);
          default:
            throw Exception('Invalid user status');
        }
      }
    }
  }

  @override
  Future<void> updateCurrentChallenge(EChallenge? challenge) async {
    await _localProvider.setCurrentChallenge(challenge);
  }

  double _calculateSavedTotalDeltaCO2(
    double localDeltaCO2,
    double remoteDeltaCO2,
  ) {
    if (_localProvider.getSynced()) {
      return localDeltaCO2.abs() >= remoteDeltaCO2.abs()
          ? localDeltaCO2
          : remoteDeltaCO2;
    } else {
      return localDeltaCO2 + remoteDeltaCO2;
    }
  }

  @override
  Future<List<FollowState>> readUsers(String searchWord) async {
    List<dynamic> users = await _remoteProvider.getUsers(searchWord);
    Map<String, bool> isFollowings = {
      for (var e in users) e['id'] as String: false
    };

    List<String> followings = (await _followProvider.getFollowings()).map((e) {
      return e['id'] as String;
    }).toList();

    for (int i = 0; i < users.length; i++) {
      if (followings.contains(users[i]['id'])) {
        isFollowings[users[i]['id']] = true;
      }
    }

    List<dynamic> afterUsers = users.asMap().entries.map((e) {
      e.value['is_following'] = isFollowings[e.value['id']];
      return e.value;
    }).toList();

    return afterUsers.map((user) {
      return FollowState.fromJson(user);
    }).toList();
  }

  @override
  Future<void> deleteUser() async {
    await _localProvider.dispose();
  }
}
