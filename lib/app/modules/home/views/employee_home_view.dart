import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/home/controllers/home_controller.dart';
import 'package:next_gen/app/shared/widgets/role_based_layout.dart';
import 'package:next_gen/core/theme/role_themes.dart';
import 'package:next_gen/ui/components/buttons/role_adaptive_button.dart';
import 'package:next_gen/widgets/neopop_card.dart';

/// Home screen for employee users
class EmployeeHomeView extends GetView<HomeController> {
  /// Creates an employee home view
  const EmployeeHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return RoleBasedLayout(
      title: 'Home',
      body: RefreshIndicator(
        onRefresh: controller.refreshJobs,
        color: RoleThemes.employeePrimary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              _buildWelcomeSection(context),
              const SizedBox(height: 24),

              // Quick search bar
              _buildQuickSearchBar(context),
              const SizedBox(height: 24),

              // Job recommendations
              _buildSectionHeader(context, 'Recommended for You'),
              const SizedBox(height: 16),
              _buildJobRecommendations(context),
              const SizedBox(height: 24),

              // Recently viewed jobs
              _buildSectionHeader(context, 'Recently Viewed'),
              const SizedBox(height: 16),
              _buildRecentlyViewedJobs(context),
              const SizedBox(height: 24),

              // Application status updates
              _buildSectionHeader(context, 'Application Updates'),
              const SizedBox(height: 16),
              _buildApplicationUpdates(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final userName = controller.userName.value.isNotEmpty
          ? controller.userName.value
          : 'there';

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: RoleThemes.employeePrimary.withAlpha(25),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $userName!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: RoleThemes.employeePrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Find your dream job today',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            RoleAdaptiveButton(
              text: 'Explore Jobs',
              onPressed: () => Get.toNamed<dynamic>('/search'),
              icon: Icons.search,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildQuickSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const HeroIcon(
            HeroIcons.magnifyingGlass,
            color: RoleThemes.employeePrimary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for jobs...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  controller.searchJobs(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'See All',
            style: TextStyle(
              color: RoleThemes.employeePrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJobRecommendations(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.recommendedJobs.isEmpty) {
        return _buildEmptyState(
          context,
          'No recommendations yet',
          "We'll show personalized job recommendations here based on your profile and preferences.",
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.recommendedJobs.length,
        itemBuilder: (context, index) {
          final job = controller.recommendedJobs[index];
          return NeoPopCard(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text(job.title),
              subtitle: Text(job.company),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => controller.viewJobDetails(job.id),
            ),
          );
        },
      );
    });
  }

  Widget _buildRecentlyViewedJobs(BuildContext context) {
    return Obx(() {
      if (controller.recentlyViewedJobs.isEmpty) {
        return _buildEmptyState(
          context,
          'No recently viewed jobs',
          'Jobs you view will appear here for quick access.',
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.recentlyViewedJobs.length,
        itemBuilder: (context, index) {
          final job = controller.recentlyViewedJobs[index];
          return NeoPopCard(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text(job.title),
              subtitle: Text(job.company),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => controller.viewJobDetails(job.id),
            ),
          );
        },
      );
    });
  }

  Widget _buildApplicationUpdates(BuildContext context) {
    return Obx(() {
      if (controller.applicationUpdates.isEmpty) {
        return _buildEmptyState(
          context,
          'No application updates',
          'Updates on your job applications will appear here.',
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.applicationUpdates.length,
        itemBuilder: (context, index) {
          final update = controller.applicationUpdates[index];
          return NeoPopCard(
            color: Theme.of(context).cardColor,
            child: ListTile(
              title: Text(update.jobTitle),
              subtitle: Text(update.status),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => controller.viewApplicationDetails(update.id),
            ),
          );
        },
      );
    });
  }

  Widget _buildEmptyState(BuildContext context, String title, String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 48,
            color: RoleThemes.employeePrimary.withAlpha(128),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
