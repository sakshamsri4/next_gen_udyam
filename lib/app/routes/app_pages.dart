import 'package:get/get.dart';

import 'package:next_gen/app/middleware/auth_middleware.dart';
import 'package:next_gen/app/middleware/onboarding_middleware.dart';
import 'package:next_gen/app/modules/auth/bindings/auth_binding.dart';
import 'package:next_gen/app/modules/auth/views/auth_view.dart';
import 'package:next_gen/app/modules/auth/views/forgot_password_view.dart';
import 'package:next_gen/app/modules/auth/views/login_view.dart';
import 'package:next_gen/app/modules/auth/views/signup_view.dart';
import 'package:next_gen/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:next_gen/app/modules/dashboard/views/dashboard_view.dart';
import 'package:next_gen/app/modules/error/bindings/error_binding.dart';
import 'package:next_gen/app/modules/error/views/error_view.dart';
import 'package:next_gen/app/modules/home/views/home_view.dart';
import 'package:next_gen/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:next_gen/app/modules/onboarding/views/onboarding_view.dart';
import 'package:next_gen/app/modules/search/bindings/search_binding.dart';
import 'package:next_gen/app/modules/search/views/search_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static final routes = [
    GetPage<dynamic>(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: AuthBinding(),
      middlewares: [OnboardingMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
      middlewares: [OnboardingMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      // OnboardingMiddleware has priority 1, AuthMiddleware has priority 2
      // This ensures onboarding check happens before auth check
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.signup,
      page: () => const SignupView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: _Paths.error,
      page: () => const ErrorView(),
      binding: ErrorBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: _Paths.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    // Placeholder routes for bottom navigation
    // These will be implemented later
    GetPage<dynamic>(
      name: _Paths.jobs,
      page: () => const DashboardView(),
      // Temporary - will be replaced with JobsView
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.resume,
      page: () => const DashboardView(),
      // Temporary - will be replaced with ResumeView
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.profile,
      page: () => const DashboardView(),
      // Temporary - will be replaced with ProfileView
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
  ];
}
