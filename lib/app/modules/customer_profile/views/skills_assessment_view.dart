import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/customer_profile/controllers/customer_profile_controller.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/custom_drawer.dart';
import 'package:next_gen/app/shared/widgets/unified_bottom_nav.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/widgets/neopop_button.dart';

/// View for skills assessment
class SkillsAssessmentView extends GetView<CustomerProfileController> {
  /// Constructor
  const SkillsAssessmentView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigationController = Get.find<NavigationController>();

    // Create a local scaffold key for this view
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Skills Assessment'),
        centerTitle: true,
        leading: IconButton(
          icon: const HeroIcon(HeroIcons.bars3),
          onPressed: () => navigationController.toggleDrawer(scaffoldKey),
        ),
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const UnifiedBottomNav(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Assess Your Skills',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Rate your proficiency in various skills to help employers find you',
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 24.h),

            // Technical skills section
            _buildSkillsSection(
              theme,
              'Technical Skills',
              [
                'Flutter',
                'Dart',
                'Firebase',
                'React',
                'JavaScript',
                'HTML/CSS',
                'Python',
                'Java',
                'SQL',
                'Git',
              ],
            ),
            SizedBox(height: 32.h),

            // Soft skills section
            _buildSkillsSection(
              theme,
              'Soft Skills',
              [
                'Communication',
                'Teamwork',
                'Problem Solving',
                'Time Management',
                'Leadership',
                'Adaptability',
                'Creativity',
                'Critical Thinking',
              ],
            ),
            SizedBox(height: 32.h),

            // Add custom skill
            _buildAddCustomSkill(theme),
            SizedBox(height: 32.h),

            // Save button
            Center(
              child: CustomNeoPopButton.primary(
                onTap: _saveSkills,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  child: const Text(
                    'Save Skills',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build skills section
  Widget _buildSkillsSection(
    ThemeData theme,
    String title,
    List<String> skills,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        ...skills.map((skill) => _buildSkillRatingItem(theme, skill)),
      ],
    );
  }

  /// Build skill rating item
  Widget _buildSkillRatingItem(ThemeData theme, String skill) {
    // Get the current rating for this skill (default to 0)
    final rating = controller.getSkillRating(skill);

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill,
                style: theme.textTheme.titleMedium,
              ),
              Text(
                _getRatingText(rating),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _getRatingColor(rating),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Slider(
              value: controller.getSkillRating(skill).toDouble(),
              max: 5,
              divisions: 5,
              activeColor: _getRatingColor(rating),
              label: _getRatingText(rating),
              onChanged: (value) => controller.updateSkillRating(
                skill,
                value.toInt(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build add custom skill section
  Widget _buildAddCustomSkill(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Custom Skill',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.customSkillController,
                decoration: const InputDecoration(
                  hintText: 'Enter skill name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            ElevatedButton(
              onPressed: controller.addCustomSkill,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.electricBlue,
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ],
    );
  }

  /// Get rating text based on rating value
  String _getRatingText(int rating) {
    switch (rating) {
      case 0:
        return 'Not Rated';
      case 1:
        return 'Beginner';
      case 2:
        return 'Basic';
      case 3:
        return 'Intermediate';
      case 4:
        return 'Advanced';
      case 5:
        return 'Expert';
      default:
        return 'Not Rated';
    }
  }

  /// Get rating color based on rating value
  Color _getRatingColor(int rating) {
    switch (rating) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow.shade800;
      case 4:
        return Colors.green;
      case 5:
        return AppTheme.electricBlue;
      default:
        return Colors.grey;
    }
  }

  /// Save skills
  void _saveSkills() {
    controller.saveSkills();
    Get.back<void>();
  }
}
