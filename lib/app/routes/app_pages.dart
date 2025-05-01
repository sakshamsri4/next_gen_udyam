import 'package:get/get.dart';

import 'package:next_gen/app/modules/auth/bindings/auth_binding.dart';
import 'package:next_gen/app/modules/auth/views/auth_view.dart';
import 'package:next_gen/app/modules/auth/views/forgot_password_view.dart';
import 'package:next_gen/app/modules/auth/views/login_view.dart';
import 'package:next_gen/app/modules/auth/views/signup_view.dart';
import 'package:next_gen/app/modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.signup,
      page: () => const SignupView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
