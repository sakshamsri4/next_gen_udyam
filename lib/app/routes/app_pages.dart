import 'package:get/get.dart';
import 'package:next_gen/app/middleware/auth_middleware.dart';
import 'package:next_gen/app/middleware/onboarding_middleware.dart';
import 'package:next_gen/app/middleware/role_middleware.dart';
import 'package:next_gen/app/modules/auth/bindings/auth_binding.dart';
import 'package:next_gen/app/modules/auth/views/auth_view.dart';
import 'package:next_gen/app/modules/auth/views/forgot_password_view.dart';
import 'package:next_gen/app/modules/auth/views/login_view.dart';
import 'package:next_gen/app/modules/auth/views/profile_view.dart';
import 'package:next_gen/app/modules/auth/views/signup_view.dart';
import 'package:next_gen/app/modules/company_profile/bindings/company_profile_binding.dart';
import 'package:next_gen/app/modules/company_profile/views/company_profile_view.dart';
import 'package:next_gen/app/modules/customer_profile/bindings/customer_profile_binding.dart';
import 'package:next_gen/app/modules/customer_profile/views/customer_profile_view.dart';
import 'package:next_gen/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:next_gen/app/modules/dashboard/views/dashboard_view.dart';
import 'package:next_gen/app/modules/error/bindings/error_binding.dart';
import 'package:next_gen/app/modules/error/views/error_view.dart';
import 'package:next_gen/app/modules/home/bindings/home_binding.dart';
import 'package:next_gen/app/modules/home/views/home_view.dart';
import 'package:next_gen/app/modules/job_details/bindings/job_details_binding.dart';
import 'package:next_gen/app/modules/job_details/views/job_details_view.dart';
import 'package:next_gen/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:next_gen/app/modules/onboarding/views/onboarding_view.dart';
import 'package:next_gen/app/modules/resume/bindings/resume_binding.dart';
import 'package:next_gen/app/modules/resume/views/resume_view.dart';
import 'package:next_gen/app/modules/role_selection/bindings/role_selection_binding.dart';
import 'package:next_gen/app/modules/role_selection/views/role_selection_view.dart';
import 'package:next_gen/app/modules/saved_jobs/bindings/saved_jobs_binding.dart';
import 'package:next_gen/app/modules/saved_jobs/views/saved_jobs_view.dart';
import 'package:next_gen/app/modules/search/bindings/search_binding.dart';
import 'package:next_gen/app/modules/search/views/search_view.dart';
import 'package:next_gen/app/modules/showcase/bindings/showcase_binding.dart';
import 'package:next_gen/app/modules/showcase/views/showcase_view.dart';
import 'package:next_gen/app/shared/bindings/navigation_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static final routes = [
    GetPage<dynamic>(
      name: _Paths.home,
      page: () => const HomeView(),
      bindings: [HomeBinding(), AuthBinding()],
      middlewares: [OnboardingMiddleware(), AuthMiddleware(), RoleMiddleware()],
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
      bindings: [DashboardBinding(), NavigationBinding()],
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware(), RoleMiddleware()],
    ),
    // Jobs route using JobDetailsView for job details
    GetPage<dynamic>(
      name: _Paths.jobs,
      page: () => const JobDetailsView(),
      bindings: [JobDetailsBinding(), NavigationBinding()],
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.resume,
      page: () => const ResumeView(),
      bindings: [ResumeBinding(), NavigationBinding()],
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.profile,
      page: () => const ProfileView(),
      bindings: [AuthBinding(), NavigationBinding()],
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.customerProfile,
      page: () => const CustomerProfileView(),
      bindings: [CustomerProfileBinding(), NavigationBinding()],
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.companyProfile,
      page: () => const CompanyProfileView(),
      bindings: [CompanyProfileBinding(), NavigationBinding()],
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.search,
      page: () => const SearchView(),
      bindings: [SearchBinding(), NavigationBinding()],
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.showcase,
      page: () => const ShowcaseView(),
      binding: ShowcaseBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware(), OnboardingMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.savedJobs,
      page: () => const SavedJobsView(),
      bindings: [SavedJobsBinding(), NavigationBinding()],
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    // Settings page (placeholder)
    GetPage<dynamic>(
      name: _Paths.settings,
      page: () => const ErrorView(message: 'Settings page coming soon'),
      binding: ErrorBinding(),
      transition: Transition.fadeIn,
    ),
    // Support page (placeholder)
    GetPage<dynamic>(
      name: _Paths.support,
      page: () => const ErrorView(message: 'Support page coming soon'),
      binding: ErrorBinding(),
      transition: Transition.fadeIn,
    ),
    // About page (placeholder)
    GetPage<dynamic>(
      name: _Paths.about,
      page: () => const ErrorView(message: 'About page coming soon'),
      binding: ErrorBinding(),
      transition: Transition.fadeIn,
    ),
    // Role selection page
    GetPage<dynamic>(
      name: _Paths.roleSelection,
      page: () => const RoleSelectionView(),
      binding: RoleSelectionBinding(),
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
  ];
}
