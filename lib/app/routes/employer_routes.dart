import 'package:get/get.dart';
import 'package:next_gen/app/modules/applicant_review/bindings/applicant_review_binding.dart';
import 'package:next_gen/app/modules/applicant_review/views/applicant_review_view.dart';
import 'package:next_gen/app/modules/auth/bindings/auth_binding.dart';
import 'package:next_gen/app/modules/company_profile/bindings/company_profile_binding.dart';
import 'package:next_gen/app/modules/company_profile/views/company_profile_view.dart';
import 'package:next_gen/app/modules/employer/bindings/employer_dashboard_binding.dart';
import 'package:next_gen/app/modules/employer/views/employer_dashboard_view.dart';
import 'package:next_gen/app/modules/job_posting/bindings/job_posting_binding.dart';
import 'package:next_gen/app/modules/job_posting/views/job_posting_view.dart';
import 'package:next_gen/app/modules/search/bindings/search_binding.dart';
import 'package:next_gen/app/modules/search/views/search_view.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/app/shared/bindings/navigation_binding.dart';

/// Routes specific to employer users
class EmployerRoutes {
  /// Private constructor to prevent instantiation
  EmployerRoutes._();

  /// Get all employer-specific routes
  static List<GetPage<dynamic>> get routes => [
        // Dashboard tab
        GetPage<dynamic>(
          name: Routes.home,
          page: () => const EmployerDashboardView(),
          binding: EmployerDashboardBinding(),
          bindings: [NavigationBinding()],
          transition: Transition.fadeIn,
        ),

        // Jobs tab (job posting management)
        GetPage<dynamic>(
          name: Routes.jobPosting,
          page: () => const JobPostingView(),
          binding: JobPostingBinding(),
          bindings: [NavigationBinding()],
          transition: Transition.fadeIn,
        ),

        // Applicants tab
        GetPage<dynamic>(
          name: Routes.applicantReview,
          page: () => const ApplicantReviewView(),
          binding: ApplicantReviewBinding(),
          bindings: [NavigationBinding()],
          transition: Transition.fadeIn,
        ),

        // Search tab (legacy)
        GetPage<dynamic>(
          name: Routes.search,
          page: () => const SearchView(),
          binding: SearchBinding(),
          bindings: [NavigationBinding()],
          transition: Transition.fadeIn,
        ),

        // Company tab (company profile and settings)
        GetPage<dynamic>(
          name: Routes.companyProfile,
          page: () => const CompanyProfileView(),
          binding: CompanyProfileBinding(),
          bindings: [NavigationBinding(), AuthBinding()],
          transition: Transition.fadeIn,
        ),
      ];
}
