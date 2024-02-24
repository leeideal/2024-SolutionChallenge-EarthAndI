import 'package:earth_and_i/bindings/friend_binding.dart';
import 'package:earth_and_i/bindings/root_binding.dart';
import 'package:earth_and_i/bindings/setting_binding.dart';
import 'package:earth_and_i/bindings/sign_in_binding.dart';
import 'package:earth_and_i/middlewares/on_boarding_middleware.dart';
import 'package:earth_and_i/views/friend/friend_screen.dart';
import 'package:earth_and_i/views/on_boarding/on_boarding_screen.dart';
import 'package:earth_and_i/views/root/root_screen.dart';
import 'package:earth_and_i/views/setting/setting_screen.dart';
import 'package:earth_and_i/views/sign_in/sign_in_screen.dart';
import 'package:earth_and_i/views/challenge_authentication/challenge_authentication_screen.dart';
import 'package:earth_and_i/bindings/challenge_authenticatiton_binding.dart';

import 'package:get/get.dart';

import 'app_routes.dart';

List<GetPage> appPages = [
  GetPage(
    name: Routes.ROOT,
    page: () => const RootScreen(),
    binding: RootBinding(),
    middlewares: [
      OnBoardingMiddleware(),
    ],
  ),
  GetPage(name: Routes.ON_BOARDING, page: () => const OnBoardingScreen()),
  GetPage(
    name: Routes.SIGN_IN,
    page: () => const SignInScreen(),
    binding: SignInBinding(),
  ),
  GetPage(
    name: Routes.SETTING,
    page: () => const SettingScreen(),
    binding: SettingBinding(),
  ),
  GetPage(
    name: Routes.FRIEND,
    page: () => const FriendScreen(),
    binding: FriendBinding(),
  ),
  GetPage(
    name: Routes.CHALLENGE_AUTHENTICATION,
    page: () => const ChallengeAuthenticationScreen(),
    binding: ChallengeAuthenticationBinding(),
  ),
];
