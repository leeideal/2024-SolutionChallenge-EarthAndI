import 'package:earth_and_i/utilities/system/color_system.dart';
import 'package:earth_and_i/utilities/system/font_system.dart';
import 'package:earth_and_i/view_models/sign_in/sign_in_view_model.dart';
import 'package:earth_and_i/views/sign_in/widget/overlay_grey_barrier.dart';
import 'package:earth_and_i/widgets/appbar/default_back_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SignInScreen extends GetView<SignInViewModel> {
  const SignInScreen({super.key});

  SignInViewModel get viewModel => controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: buildAppBar(context),
          body: SafeArea(
            child: buildBody(context),
          ),
          backgroundColor: ColorSystem.white,
        ),
        const OverlayGreyBarrier(),
      ],
    );
  }

  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: DefaultBackAppBar(
        title: "sign_in".tr,
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        ..._titleView(),
        const SizedBox(height: 20),
        Expanded(
          child: _buildTermsView(),
        ),
        const SizedBox(height: 20),
        MaterialButton(
          onPressed: _onPressedSignInButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          padding: const EdgeInsets.all(16),
          color: ColorSystem.green,
          child: SizedBox(
            width: Get.width - 64,
            child: Text(
              "sign_in_btn".tr,
              style: FontSystem.KR24M.copyWith(
                fontSize: 22,
                color: ColorSystem.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  List<Widget> _titleView() => [
        Container(
          decoration: BoxDecoration(
            color: ColorSystem.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: ColorSystem.grey,
                offset: const Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
          child: SvgPicture.asset(
            'assets/images/app_icon.svg',
            width: 80,
            height: 80,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Earth & I",
          style: FontSystem.KR20M,
        ),
      ];

  Widget _buildTermsView() => Container(
        width: Get.width - 32,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorSystem.grey[200],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          "sign_in_conditions".tr,
          style: FontSystem.KR16M,
          textAlign: TextAlign.left,
        ),
      );

  void _onPressedSignInButton() {
    viewModel.signInWithGoogle().then((value) {
      if (value) {
        Get.back();
        Get.snackbar(
          'sign_in_success'.tr,
          'sign_in_success_long'.tr,
          snackPosition: SnackPosition.TOP,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          duration: const Duration(seconds: 2),
          backgroundColor: ColorSystem.grey.withOpacity(0.3),
        );
      } else {
        Get.snackbar(
          'sign_in_failed'.tr,
          'sign_in_failed_long'.tr,
          snackPosition: SnackPosition.TOP,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          duration: const Duration(seconds: 2),
          backgroundColor: ColorSystem.grey.withOpacity(0.3),
        );
      }
    });
  }
}
