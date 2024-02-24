import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:earth_and_i/utilities/system/color_system.dart';
import 'package:earth_and_i/utilities/system/font_system.dart';
import 'package:earth_and_i/view_models/load_map/load_map_view_model.dart';
import 'package:earth_and_i/views/base/base_screen.dart';
import 'package:earth_and_i/views/load_map/widgets/challenge_history_item.dart';
import 'package:earth_and_i/widgets/dialog/challenge_dialog.dart';
import 'package:earth_and_i/widgets/line/infinity_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class LoadMapScreen extends BaseScreen<LoadMapViewModel> {
  const LoadMapScreen({super.key});

  @override
  bool get wrapWithOuterSafeArea => true;

  @override
  bool get setTopOuterSafeArea => true;

  @override
  bool get setBottomOuterSafeArea => false;

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _persistentAnimationView(),
            const SizedBox(height: 12),
            _textsHintView(),
            const SizedBox(height: 20),
            _currentChallengeView(),
            const SizedBox(height: 20),
            InfinityLine(
              height: 2,
              color: ColorSystem.grey[200],
            ),
            const SizedBox(height: 20),
            _completedChallengeView(),
          ],
        ),
      ),
    );
  }

  Widget _persistentAnimationView() => Center(
        child: SizedBox(
          width: 120,
          height: 120,
          child: RiveAnimation.asset(
            "assets/riv/persistent_animation_earth.riv",
            fit: BoxFit.cover,
            alignment: Alignment.center,
            controllers: [
              viewModel.animationController,
            ],
          ),
        ),
      );

  Widget _textsHintView() => SizedBox(
        width: Get.width,
        height: 40,
        child: Center(
          child: DefaultTextStyle(
            style: FontSystem.KR16M,
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                for (int i = 0; i < 3; i++)
                  FadeAnimatedText(
                    'hint_text_$i'.tr,
                    textAlign: TextAlign.center,
                    duration: const Duration(seconds: 3),
                  ),
              ],
            ),
          ),
        ),
      );

  Widget _currentChallengeView() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "current_challenge".tr,
            style: FontSystem.KR20SB120,
          ),
          const SizedBox(height: 16),
          Obx(
            () => ChallengeHistoryItem(
              state: viewModel.currentChallengeState,
              borderColor: ColorSystem.green,
              onTap: () {
                Get.dialog(
                  ChallengeDialog(state: viewModel.currentChallengeState),
                );
              },
            ),
          ),
        ],
      );

  Widget _completedChallengeView() => Column(
        children: [
          Row(
            children: [
              Text(
                "completed_challenge".tr,
                style: FontSystem.KR20SB120,
              ),
              const SizedBox(width: 8),
              Obx(
                () => Text(
                  "${viewModel.challengeHistoryStates.length}",
                  style: FontSystem.KR20SB120.copyWith(color: ColorSystem.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: viewModel.challengeHistoryStates.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, index) {
                return Column(
                  children: [
                    ChallengeHistoryItem(
                      state: viewModel.challengeHistoryStates[index],
                      borderColor: ColorSystem.grey,
                      onTap: () {
                        Get.dialog(
                          ChallengeDialog(
                            state: viewModel.challengeHistoryStates[index],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      );
}
