import 'package:earth_and_i/apps/database/local_database.dart';
import 'package:earth_and_i/apps/factory/local_database_factory.dart';
import 'package:earth_and_i/domains/converter/e_type_converter.dart';
import 'package:earth_and_i/domains/type/e_action.dart';
import 'package:earth_and_i/domains/type/e_user_status.dart';
import 'package:earth_and_i/models/home/carbon_cloud_state.dart';
import 'package:earth_and_i/models/profile/action_history_state.dart';
import 'package:earth_and_i/models/profile/daily_carbon_state.dart';
import 'package:earth_and_i/models/profile/daily_delta_co2_state.dart';
import 'package:earth_and_i/models/profile/total_carbon_state.dart';
import 'package:earth_and_i/providers/action_history_local_provider.dart';
import 'package:earth_and_i/utilities/functions/dev_on_log.dart';
import 'package:get/get.dart';

class ActionHistoryRepository extends GetxService {
  late final ActionHistoryLocalProvider _localProvider;

  static final List<List<EAction>> _actionGroups = [
    [],
    [
      EAction.meal,
      EAction.publicTransportation,
      EAction.sns,
    ],
    [
      EAction.meal,
      EAction.tumbler,
      EAction.stairs,
      EAction.recycle,
    ],
    [
      EAction.optimalTemperature,
      EAction.meal,
      EAction.sns,
      EAction.waterUsage,
      EAction.standbyPower,
    ],
  ];

  @override
  void onInit() {
    super.onInit();
    _localProvider = LocalDatabaseFactory.instance.actionHistoryDao;
  }

  /* ----------------------------------------------------- */
  /* ----------------------- State ----------------------- */
  /* ----------------------------------------------------- */
  Future<List<CarbonCloudState>> readCarbonCloudStates(
    DateTime currentAt,
  ) async {
    // 00 ~ 06시면, _actionGroups[0]
    // 06 ~ 12시면, _actionGroups[1]
    // 12 ~ 18시면, _actionGroups[2]
    // 18 ~ 24시면, _actionGroups[3]
    // 위 값을 구하고 현재 시간에 해당하는 액션들을 가져온다.
    int groupIndex = currentAt.hour ~/ 6;
    List<EAction> actions = _actionGroups[groupIndex];

    if (groupIndex == 0) {
      return [];
    }

    // 현재 시간에 해당하는 시간 범위를 구한다.
    DateTime startAt = DateTime(currentAt.year, currentAt.month, currentAt.day,
        0 + 6 * groupIndex, 0, 0);
    DateTime endAt = DateTime(currentAt.year, currentAt.month, currentAt.day,
        5 + 6 * groupIndex, 59, 59);

    // 위에서 구한 값을 기반으로 액션 히스토리를 가져온다.
    List<ActionHistoryData> histories =
        await _localProvider.findAllByTypesAndDateRange(
      actions,
      startAt,
      endAt,
    );

    // actions와 histories를 비교하여, 해당 시간에 해당하는 액션을 수행했는지 확인한다.
    // 수행했다면, 해당 액션의 타입이 없을 때, CarbonCloudState로 변환하여 반환한다.
    int index = 0;
    List<CarbonCloudState> states = [];
    for (var action in actions) {
      if (histories.indexWhere((element) => element.type == action) == -1) {
        // groupIndex에 따라서 dawn, morning, afternoon, evening을 설정한다.
        states.add(CarbonCloudState(
          shortQuestion: "${action.getContent(groupIndex)}_short",
          longQuestion: "${action.getContent(groupIndex)}_long",
          exampleAnswer: "${action.getContent(groupIndex)}_example_answer",
          userStatus: ETypeConverter.actionToUserStatus(action),
          action: action,
          isLeftPos: index.isEven,
        ));

        index++;
      }
    }

    return states;
  }

  Future<DailyDeltaCO2State> readDailyDeltaCO2State(DateTime currentAt) async {
    DateTime startAt = DateTime(currentAt.year, currentAt.month, currentAt.day);
    DateTime endAt =
        DateTime(currentAt.year, currentAt.month, currentAt.day, 23, 59, 59);

    List<ActionHistoryData> histories = await _localProvider.findAllByDateRange(
      startAt,
      endAt,
    );

    // Delta CO2
    double positiveDeltaCO2 = 0;
    double negativeDeltaCO2 = 0;

    // Count
    int healthPositiveCnt = 0;
    int healthNegativeCnt = 0;
    int mentalPositiveCnt = 0;
    int mentalNegativeCnt = 0;
    int cashPositiveCnt = 0;
    int cashNegativeCnt = 0;

    for (var history in histories) {
      if (history.changeCapacity > 0) {
        negativeDeltaCO2 += history.changeCapacity;
      } else {
        positiveDeltaCO2 += history.changeCapacity;
      }

      switch (history.userStatus) {
        case EUserStatus.health:
          if (history.changeCapacity > 0) {
            healthNegativeCnt++;
          } else {
            healthPositiveCnt++;
          }
          break;
        case EUserStatus.mental:
          if (history.changeCapacity > 0) {
            mentalNegativeCnt++;
          } else {
            mentalPositiveCnt++;
          }
          break;
        case EUserStatus.cash:
          if (history.changeCapacity > 0) {
            cashNegativeCnt++;
          } else {
            cashPositiveCnt++;
          }
          break;
        default:
          break;
      }
    }

    DailyDeltaCO2State currentState = DailyDeltaCO2State(
      positiveDeltaCO2: positiveDeltaCO2,
      negativeDeltaCO2: negativeDeltaCO2,
      healthPositiveCnt: healthPositiveCnt,
      healthNegativeCnt: healthNegativeCnt,
      mentalPositiveCnt: mentalPositiveCnt,
      mentalNegativeCnt: mentalNegativeCnt,
      cashPositiveCnt: cashPositiveCnt,
      cashNegativeCnt: cashNegativeCnt,
    );

    DevOnLog.i(currentState);

    return currentState;
  }

  Future<List<ActionHistoryState>> readActionHistoryStates(
    DateTime currentAt,
  ) async {
    DateTime startAt = DateTime(currentAt.year, currentAt.month, currentAt.day);
    DateTime endAt =
        DateTime(currentAt.year, currentAt.month, currentAt.day, 23, 59, 59);

    List<ActionHistoryData> histories = await _localProvider.findAllByDateRange(
      startAt,
      endAt,
    );

    List<ActionHistoryState> states =
        histories.map((e) => ActionHistoryState.fromData(e)).toList();

    // histories에서 EAction.steps를 맨 앞으로 보내고, 없다면 새로운 값을 추가해준다.
    if (states.indexWhere((element) => element.type == EAction.steps) == -1) {
      states.insert(
        0,
        ActionHistoryState(
          characterStatus: '',
          createdAt: DateTime.now(),
          changeCapacity: 0,
          type: EAction.steps,
          question: '',
          answer: '0',
        ),
      );
    } else {
      ActionHistoryState steps = states.removeAt(
        states.indexWhere((element) => element.type == EAction.steps),
      );

      states.insert(0, steps);
    }

    return states;
  }

  /* ----------------------------------------------------- */
  /* ---------------------- DataBase --------------------- */
  /* ----------------------------------------------------- */
  Future<ActionHistoryData> createOrUpdate(ActionHistoryCompanion data) async {
    try {
      return await _localProvider.save(data);
    } on Exception catch (e) {
      DevOnLog.e(e);
      rethrow;
    }
  }

  Future<ActionHistoryData?> readOneByTypeAndDateRange(
    EAction type,
    DateTime startAt,
    DateTime endAt,
  ) async {
    try {
      return await _localProvider.findByTypeAndDateRange(type, startAt, endAt);
    } on Exception catch (e) {
      DevOnLog.e(e);
      rethrow;
    }
  }

  Future<List<ActionHistoryData>> readAllByDateRange(
    DateTime startAt,
    DateTime endAt,
  ) async {
    try {
      return await _localProvider.findAllByDateRange(startAt, endAt);
    } on Exception catch (e) {
      DevOnLog.e(e);
      rethrow;
    }
  }

  Future<DailyCarbonState> readDailyCarbonState(
    DateTime startAt,
    DateTime endAt,
  ) async {
    List<ActionHistoryData> histories =
        await _localProvider.findAllByDateRange(startAt, endAt);

    DailyCarbonState currentState = DailyCarbonState.initial();

    for (var history in histories) {
      switch (history.userStatus) {
        case EUserStatus.health:
          if (history.changeCapacity > 0) {
            currentState = currentState.copyWith(
              healthNegativeCnt: currentState.healthNegativeCnt + 1,
            );
          } else {
            currentState = currentState.copyWith(
              healthPositiveCnt: currentState.healthPositiveCnt + 1,
            );
          }
          break;
        case EUserStatus.mental:
          if (history.changeCapacity > 0) {
            currentState = currentState.copyWith(
              mentalNegativeCnt: currentState.mentalNegativeCnt + 1,
            );
          } else {
            currentState = currentState.copyWith(
              mentalPositiveCnt: currentState.mentalPositiveCnt + 1,
            );
          }
          break;
        case EUserStatus.cash:
          if (history.changeCapacity > 0) {
            currentState = currentState.copyWith(
              cashNegativeCnt: currentState.cashNegativeCnt + 1,
            );
          } else {
            currentState = currentState.copyWith(
              cashPositiveCnt: currentState.cashPositiveCnt + 1,
            );
          }
          break;
        default:
          break;
      }
    }
    return currentState;
  }

  Future<TotalCarbonState> readTotalCarbonState(
    DateTime startAt,
    DateTime endAt,
  ) async {
    List<ActionHistoryData> histories =
        await _localProvider.findAllByDateRange(startAt, endAt);

    TotalCarbonState currentState = TotalCarbonState.initial();
    for (var history in histories) {
      if (history.changeCapacity > 0) {
        currentState = currentState.copyWith(
            negativeTotalDeltaCO2:
                currentState.negativeTotalDeltaCO2 + history.changeCapacity);
      } else {
        currentState = currentState.copyWith(
            positiveTotalDeltaCO2:
                currentState.positiveTotalDeltaCO2 + history.changeCapacity);
      }
    }
    currentState = currentState.copyWith(
        totalDeltaCO2: currentState.positiveTotalDeltaCO2 +
            currentState.negativeTotalDeltaCO2);
    return currentState;
  }
}
