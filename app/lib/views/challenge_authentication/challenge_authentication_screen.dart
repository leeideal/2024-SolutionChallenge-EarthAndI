import 'dart:io';
import 'package:earth_and_i/utilities/functions/dev_on_log.dart';
import 'package:earth_and_i/utilities/system/color_system.dart';
import 'package:earth_and_i/utilities/system/font_system.dart';
import 'package:earth_and_i/view_models/challenge_authentication/challenge_authentication_view_model.dart';
import 'package:earth_and_i/views/base/base_screen.dart';
import 'package:earth_and_i/widgets/appbar/default_back_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChallengeAuthenticationScreen
    extends BaseScreen<ChallengeAuthenticationViewModel> {
  const ChallengeAuthenticationScreen({super.key});

  @override
  bool get wrapWithOuterSafeArea => true;

  @override
  bool get setTopOuterSafeArea => true;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: DefaultBackAppBar(
        title: "챌린지 인증하기",
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Get.arguments.shortTitle.toString().tr,
              style: FontSystem.KR20SB120),
          const SizedBox(height: 8),
          Text(Get.arguments.longTitle.toString().tr, style: FontSystem.KR16M),
          const SizedBox(height: 20),
          Obx(
            () => viewModel.image == null
                ? Expanded(
                    child: Center(
                      child: Container(
                        color: ColorSystem.grey[100],
                      ),
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: Image.file(
                        File(viewModel.image!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: Get.width * 0.92,
              height: 56,
              child: OutlinedButton(
                onPressed: () => viewModel.getImage(),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: ColorSystem.green[500],
                  textStyle: FontSystem.KR20M,
                  foregroundColor: Colors.white,
                  side: BorderSide(
                    color: ColorSystem.green[500]!,
                    width: 1,
                  ),
                ),
                child: const Text("사진 선택하기"),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
                width: Get.width * 0.92,
                height: 56,
                child: Obx(
                  () => viewModel.image == null
                      ? OutlinedButton(
                          onPressed: () {
                            Get.snackbar("사진이 없어요 :(", "사진을 선택해주세요!");
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: ColorSystem.grey[100],
                            textStyle: FontSystem.KR20M,
                            foregroundColor: ColorSystem.grey[500],
                            side: BorderSide(
                              color: ColorSystem.grey[100]!,
                              width: 1,
                            ),
                          ),
                          child: const Text("인증하기"),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            DevOnLog.i("사진 인증하기");
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: ColorSystem.green[500],
                            textStyle: FontSystem.KR20M,
                            foregroundColor: ColorSystem.white,
                            side: BorderSide(
                              color: ColorSystem.green[500]!,
                              width: 1,
                            ),
                          ),
                          child: const Text("인증하기"),
                        ),
                )),
          )
        ],
      ),
    );
  }
}
