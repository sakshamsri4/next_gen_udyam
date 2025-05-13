import 'package:get/get.dart';
import 'package:next_gen/app/middleware/auth_middleware.dart';
import 'package:next_gen/app/middleware/onboarding_middleware.dart';
import 'package:next_gen/app/middleware/role_middleware.dart';
import 'package:next_gen/app/modules/admin/views/admin_dashboard_view.dart';
import 'package:next_gen/app/modules/applications/bindings/applications_binding.dart';
import 'package:next_gen/app/modules/applications/views/application_details_view.dart';
import 'package:next_gen/app/modules/applications/views/applications_view.dart';
import 'package:next_gen/app/modules/auth/bindings/auth_binding.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/views/auth_view.dart';
import 'package:next_gen/app/modules/auth/views/forgot_password_view.dart';
import 'package:next_gen/app/modules/auth/views/login_view.dart';
import 'package:next_gen/app/modules/auth/views/profile_view.dart';
import 'package:next_gen/app/modules/auth/views/signup_view.dart';
import 'package:next_gen/app/modules/auth/views/verification_success_view.dart';
import 'package:next_gen/app/modules/auth/views/welcome_view.dart';
import 'package:next_gen/app/modules/company_profile/bindings/company_profile_binding.dart';
import 'package:next_gen/app/modules/company_profile/views/company_profile_view.dart';
import 'package:next_gen/app/modules/customer_profile/bindings/customer_profile_binding.dart';
import 'package:next_gen/app/modules/customer_profile/views/customer_profile_view.dart';
import 'package:next_gen/app/modules/customer_profile/views/skills_assessment_view.dart';
import 'package:next_gen/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:next_gen/app/modules/dashboard/views/dashboard_view.dart';
import 'package:next_gen/app/modules/employee/views/discover_view.dart';
import 'package:next_gen/app/modules/employer/views/employer_dashboard_view.dart';
import 'package:next_gen/app/modules/error/bindings/error_binding.dart';
import 'package:next_gen/app/modules/error/views/error_view.dart';
import 'package:next_gen/app/modules/home/bindings/home_binding.dart';
import 'package:next_gen/app/modules/home/views/home_view.dart';
import 'package:next_gen/app/modules/job_details/bindings/job_details_binding.dart';
import 'package:next_gen/app/modules/job_details/views/job_details_view.dart';
import 'package:next_gen/app/modules/job_details/views/test_job_details_view.dart';
import 'package:next_gen/app/modules/job_posting/bindings/job_posting_binding.dart';
import 'package:next_gen/app/modules/job_posting/views/job_posting_view.dart';
import 'package:next_gen/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:next_gen/app/modules/onboarding/views/onboarding_view.dart';
import 'package:next_gen/app/modules/resume/bindings/resume_binding.dart';
import 'package:next_gen/app/modules/resume/views/resume_builder_view.dart';
import 'package:next_gen/app/modules/resume/views/resume_view.dart';
import 'package:next_gen/app/modules/role_selection/bindings/role_selection_binding.dart';
import 'package:next_gen/app/modules/role_selection/views/role_selection_view.dart';
import 'package:next_gen/app/modules/saved_jobs/bindings/saved_jobs_binding.dart';
import 'package:next_gen/app/modules/saved_jobs/views/saved_jobs_view.dart';
import 'package:next_gen/app/modules/search/bindings/search_binding.dart';
import 'package:next_gen/app/modules/search/views/search_view.dart';
import 'package:next_gen/app/modules/showcase/bindings/showcase_binding.dart';
import 'package:next_gen/app/modules/showcase/views/showcase_view.dart';
import 'package:next_gen/app/routes/admin_routes.dart';
import 'package:next_gen/app/routes/employee_routes.dart';
import 'package:next_gen/app/routes/employer_routes.dart';
import 'package:next_gen/app/shared/bindings/navigation_binding.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static final routes = [
    // Use role-specific routes based on user role
    GetPage<dynamic>(
      name: _Paths.home,
      page: () {
        // Get the navigation controller to determine the user role
        try {
          final navigationController = Get.find<NavigationController>();
          final userRole = navigationController.userRole.value;

          // Return the appropriate view based on role
          switch (userRole) {
            case UserType.employee:
              return DiscoverView();
            case UserType.employer:
              return const EmployerDashboardView();
            case UserType.admin:
              return const AdminDashboardView();
            case null:
              return const HomeView();
          }
        } catch (e) {
          // If we can't determine the role, fall back to the default view
          return const HomeView();
        }
      },
      bindings: [HomeBinding(), AuthBinding(), NavigationBinding()],
      middlewares: [OnboardingMiddleware(), AuthMiddleware(), RoleMiddleware()],
    ),

    // Include role-specific routes
    ...EmployeeRoutes.routes,
    ...EmployerRoutes.routes,
    ...AdminRoutes.routes,
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
    // Test route for job details
    GetPage<dynamic>(
      name: '${_Paths.jobs}/test',
      page: () => const TestJobDetailsView(),
      bindings: [JobDetailsBinding(), NavigationBinding()],
      transition: Transition.fadeIn,
    ),
    GetPage<dynamic>(
      name: _Paths.resume,
      page: () => const ResumeView(),
      bindings: [ResumeBinding(), NavigationBinding()],
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: '${_Paths.resume}/builder',
      page: () => const ResumeBuilderView(),
      bindings: [ResumeBinding(), NavigationBinding()],
      transition: Transition.rightToLeft,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: _Paths.profile,
      page: ProfileView.new,
      bindings: [AuthBinding(), NavigationBinding()],
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    GetPage<dynamic>(
      name: '${_Paths.profile}/skills-assessment',
      page: () => const SkillsAssessmentView(),
      bindings: [CustomerProfileBinding(), NavigationBinding()],
      transition: Transition.rightToLeft,
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
    // Applications list page
    GetPage<dynamic>(
      name: _Paths.applications,
      page: ApplicationsView.new,
      bindings: [ApplicationsBinding(), NavigationBinding()],
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    // Application details page
    GetPage<dynamic>(
      name: '${_Paths.applications}/:id',
      page: () => const ApplicationDetailsView(),
      bindings: [ApplicationsBinding(), NavigationBinding()],
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    // Job posting management page
    GetPage<dynamic>(
      name: _Paths.jobPosting,
      page: () => const JobPostingView(),
      bindings: [JobPostingBinding(), NavigationBinding()],
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware(), RoleMiddleware()],
    ),
    // Welcome screen after signup
    GetPage<dynamic>(
      name: _Paths.welcome,
      page: () => const WelcomeView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
    // Email verification success screen
    GetPage<dynamic>(
      name: _Paths.verificationSuccess,
      page: () => const VerificationSuccessView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      middlewares: [OnboardingMiddleware(), AuthMiddleware()],
    ),
  ];
}
