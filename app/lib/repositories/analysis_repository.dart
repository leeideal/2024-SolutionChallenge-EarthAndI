import 'package:earth_and_i/domains/type/e_user_status.dart';
import 'package:earth_and_i/providers/analysis_provider.dart';
import 'package:get/get.dart';

class AnalysisRepository extends GetxService {
  late final AnalysisProvider _analysisProvider;

  @override
  void onInit() {
    super.onInit();
    _analysisProvider = Get.find<AnalysisProvider>();
  }

  Future<Map<String, dynamic>> analysisAction(
    EUserStatus userStatus,
    String question,
    String answer,
  ) async {
    Map<String, dynamic> result;

    try {
      result = await _analysisProvider.postAnalysisAction(
        userStatus,
        question,
        answer,
      );
    } catch (e) {
      rethrow;
    }

    bool isGood = result["carbon"]["reduce"] == " good";
    double changeCapacity = double.parse(result["carbon"]["output"]);

    return {
      "answer": result["answer"],
      "changeCapacity": isGood ? -changeCapacity : changeCapacity,
    };
  }
}
