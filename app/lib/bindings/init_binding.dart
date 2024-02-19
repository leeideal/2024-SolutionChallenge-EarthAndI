import 'package:earth_and_i/providers/analysis/analysis_provider_impl.dart';
import 'package:earth_and_i/providers/analysis_provider.dart';
import 'package:earth_and_i/repositories/action_history_repository.dart';
import 'package:earth_and_i/repositories/analysis_repository.dart';
import 'package:earth_and_i/repositories/challenge_history_repository.dart';
import 'package:earth_and_i/repositories/user_repository.dart';
import 'package:get/get.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnalysisProvider>(() => AnalysisProviderImpl());

    Get.lazyPut(() => ActionHistoryRepository());
    Get.lazyPut(() => ChallengeHistoryRepository());
    Get.lazyPut(() => AnalysisRepository());
    Get.lazyPut(() => UserRepository());
  }
}
