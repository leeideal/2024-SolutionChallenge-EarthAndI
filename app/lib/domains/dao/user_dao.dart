import 'package:earth_and_i/domains/type/e_challenge.dart';
import 'package:earth_and_i/providers/user_local_provider.dart';
import 'package:get_storage/get_storage.dart';

class UserDAO implements UserLocalProvider {
  UserDAO({
    required GetStorage storage,
  }) : _storage = storage;

  final GetStorage _storage;

  /* ------------------------------------------------------------ */
  /* ------------------------ Initialize ------------------------ */
  /* ------------------------------------------------------------ */
  /// Initialize the user data.
  @override
  Future<void> init() async {
    // User Setting
    await _storage.writeIfNull(UserDAOExtension.alarmActive, false);
    await _storage.writeIfNull(UserDAOExtension.alarmHour, 8);
    await _storage.writeIfNull(UserDAOExtension.alarmMinute, 0);

    // User Brief Information
    await _storage.writeIfNull(UserDAOExtension.id, 'GUEST');
    await _storage.writeIfNull(UserDAOExtension.nickname, 'GUEST');

    // User Detail Information
    await _storage.writeIfNull(UserDAOExtension.healthPositiveCnt, 0);
    await _storage.writeIfNull(UserDAOExtension.healthNegativeCnt, 0);
    await _storage.writeIfNull(UserDAOExtension.mentalPositiveCnt, 0);
    await _storage.writeIfNull(UserDAOExtension.mentalNegativeCnt, 0);
    await _storage.writeIfNull(UserDAOExtension.cashPositiveCnt, 0);
    await _storage.writeIfNull(UserDAOExtension.cashNegativeCnt, 0);
    await _storage.writeIfNull(UserDAOExtension.totalDeltaCO2, 0.0);

    // Character State
    await _storage.writeIfNull(UserDAOExtension.environmentCondition, true);
    await _storage.writeIfNull(UserDAOExtension.healthCondition, true);
    await _storage.writeIfNull(UserDAOExtension.mentalCondition, true);
    await _storage.writeIfNull(UserDAOExtension.cashCondition, true);
    await _storage.writeIfNull(UserDAOExtension.currentChallenge,
        EChallenge.useEcoFriendlyProducts.toString());
  }

  @override
  Future<void> deleteAll() async {
    await _storage.erase();
  }

  /* ------------------------------------------------------------ */
  /* -------------------------- Getter -------------------------- */
  /* ------------------------------------------------------------ */
  /// Get the user's alarm active state.
  @override
  bool getAlarmActive() {
    return _storage.read(UserDAOExtension.alarmActive) ?? false;
  }

  /// Get the user's alarm hour.
  @override
  int getAlarmHour() {
    return _storage.read(UserDAOExtension.alarmHour) ?? 8;
  }

  /// Get the user's alarm minute.
  @override
  int getAlarmMinute() {
    return _storage.read(UserDAOExtension.alarmMinute) ?? 0;
  }

  /// Get the user's id.
  @override
  String getId() {
    return _storage.read(UserDAOExtension.id) ?? 'GUEST';
  }

  /// Get the user's nickname.
  @override
  String getNickname() {
    return _storage.read(UserDAOExtension.nickname) ?? 'GUEST';
  }

  /// Get the user's health positive count.
  @override
  int getHealthPositiveCnt() {
    return _storage.read(UserDAOExtension.healthPositiveCnt) ?? 0;
  }

  /// Get the user's health negative count.
  @override
  int getHealthNegativeCnt() {
    return _storage.read(UserDAOExtension.healthNegativeCnt) ?? 0;
  }

  /// Get the user's mental positive count.
  @override
  int getMentalPositiveCnt() {
    return _storage.read(UserDAOExtension.mentalPositiveCnt) ?? 0;
  }

  /// Get the user's mental negative count.
  @override
  int getMentalNegativeCnt() {
    return _storage.read(UserDAOExtension.mentalNegativeCnt) ?? 0;
  }

  /// Get the user's cache positive count.
  @override
  int getCashPositiveCnt() {
    return _storage.read(UserDAOExtension.cashPositiveCnt) ?? 0;
  }

  /// Get the user's cache negative count.
  @override
  int getCashNegativeCnt() {
    return _storage.read(UserDAOExtension.cashNegativeCnt) ?? 0;
  }

  /// Get the user's total carbon dioxide.
  @override
  double getTotalDeltaCO2() {
    return _storage.read(UserDAOExtension.totalDeltaCO2) ?? 0.0;
  }

  /// Get the user's health condition.
  @override
  bool getHealthCondition() {
    return _storage.read(UserDAOExtension.healthCondition) ?? true;
  }

  /// Get the user's mental condition.
  @override
  bool getMentalCondition() {
    return _storage.read(UserDAOExtension.mentalCondition) ?? true;
  }

  /// Get the user's cash condition.
  @override
  bool getCashCondition() {
    return _storage.read(UserDAOExtension.cashCondition) ?? true;
  }

  /// Get the user's current challenge.
  @override
  EChallenge getCurrentChallenge() {
    return EChallenge.fromName(
        _storage.read(UserDAOExtension.currentChallenge) ??
            EChallenge.useEcoFriendlyProducts.toString());
  }

  /* ------------------------------------------------------------ */
  /* -------------------------- Setter -------------------------- */
  /* ------------------------------------------------------------ */
  /// Set the user's alarm active state.
  @override
  Future<void> setAlarmActive(bool isActive) async {
    await _storage.write(UserDAOExtension.alarmActive, isActive);
  }

  /// Set the user's alarm hour.
  @override
  Future<void> setAlarmHour(int hour) async {
    await _storage.write(UserDAOExtension.alarmHour, hour);
  }

  /// Set the user's alarm minute.
  @override
  Future<void> setAlarmMinute(int minute) async {
    await _storage.write(UserDAOExtension.alarmMinute, minute);
  }

  /// Set the user's id.
  @override
  Future<void> setId(String id) async {
    await _storage.write(UserDAOExtension.id, id);
  }

  /// Set the user's nickname.
  @override
  Future<void> setNickname(String nickname) async {
    await _storage.write(UserDAOExtension.nickname, nickname);
  }

  /// Set the user's health positive count.
  @override
  Future<void> setHealthPositiveCnt(int cnt) async {
    await _storage.write(UserDAOExtension.healthPositiveCnt, cnt);
  }

  /// Set the user's health negative count.
  @override
  Future<void> setHealthNegativeCnt(int cnt) async {
    await _storage.write(UserDAOExtension.healthNegativeCnt, cnt);
  }

  /// Set the user's mental positive count.
  @override
  Future<void> setMentalPositiveCnt(int cnt) async {
    await _storage.write(UserDAOExtension.mentalPositiveCnt, cnt);
  }

  /// Set the user's mental negative count.
  @override
  Future<void> setMentalNegativeCnt(int cnt) async {
    await _storage.write(UserDAOExtension.mentalNegativeCnt, cnt);
  }

  /// Set the user's cache positive count.
  @override
  Future<void> setCashPositiveCnt(int cnt) async {
    await _storage.write(UserDAOExtension.cashPositiveCnt, cnt);
  }

  /// Set the user's cache negative count.
  @override
  Future<void> setCashNegativeCnt(int cnt) async {
    await _storage.write(UserDAOExtension.cashNegativeCnt, cnt);
  }

  /// Set the user's total carbon dioxide.
  @override
  Future<void> setTotalDeltaCO2(double value) async {
    await _storage.write(UserDAOExtension.totalDeltaCO2, value);
  }

  /// Set the user's health condition.
  @override
  Future<void> setHealthCondition(bool isGood) async {
    await _storage.write(UserDAOExtension.healthCondition, isGood);
  }

  /// Set the user's mental condition.
  @override
  Future<void> setMentalCondition(bool isGood) async {
    await _storage.write(UserDAOExtension.mentalCondition, isGood);
  }

  /// Set the user's cash condition.
  @override
  Future<void> setCashCondition(bool isGood) async {
    await _storage.write(UserDAOExtension.cashCondition, isGood);
  }

  /// Set the user's current challenge.
  @override
  Future<void> setCurrentChallenge(EChallenge challenge) async {
    await _storage.write(
        UserDAOExtension.currentChallenge, challenge.toString());
  }
}

extension UserDAOExtension on UserDAO {
  // User Setting
  static const String alarmActive = 'alarm_active';
  static const String alarmHour = 'alarm_hour';
  static const String alarmMinute = 'alarm_minute';

  // User Brief Information
  static const String id = 'id';
  static const String nickname = 'nickname';

  // User Detail Information
  static const String healthPositiveCnt = 'health_positive_cnt';
  static const String healthNegativeCnt = 'health_negative_cnt';
  static const String cashPositiveCnt = 'cash_positive_cnt';
  static const String cashNegativeCnt = 'cash_negative_cnt';
  static const String mentalPositiveCnt = 'mental_positive_cnt';
  static const String mentalNegativeCnt = 'mental_negative_cnt';
  static const String totalDeltaCO2 = 'total_delta_co2';

  // Character State
  static const String environmentCondition = 'environment_condition';
  static const String healthCondition = 'health_condition';
  static const String mentalCondition = 'mental_condition';
  static const String cashCondition = 'cash_condition';

  // Challenge State
  static const String currentChallenge = 'current_challenge';
}
