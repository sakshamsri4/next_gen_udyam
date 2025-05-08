import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

import 'package:next_gen/ui/components/buttons/cred_button.dart';
import 'package:next_gen/ui/components/cards/custom_info_card.dart';
import 'package:next_gen/ui/components/cards/custom_tag.dart';
import 'package:next_gen/ui/components/fields/custom_text_field.dart';
import 'package:next_gen/ui/components/avatars/custom_avatar.dart';

/// A showcase screen for CRED-styled components
///
/// This screen demonstrates all the CRED-styled components in the app
class CredComponentsShowcase extends StatelessWidget {
  /// Creates a CRED components showcase screen
  const CredComponentsShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CRED Design Components'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Buttons', theme),
            SizedBox(height: 16.h),
            
            // Primary Button
            CredButton.primary(
              title: 'Primary Button',
              onTap: () {
                Get.snackbar(
                  'Primary Button',
                  'You tapped the primary button',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: HeroIcons.bolt,
            ),
            SizedBox(height: 16.h),
            
            // Secondary Button
            CredButton.secondary(
              title: 'Secondary Button',
              onTap: () {
                Get.snackbar(
                  'Secondary Button',
                  'You tapped the secondary button',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            SizedBox(height: 16.h),
            
            // Success Button
            CredButton.success(
              title: 'Success Button',
              onTap: () {
                Get.snackbar(
                  'Success Button',
                  'You tapped the success button',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: HeroIcons.check,
            ),
            SizedBox(height: 16.h),
            
            // Danger Button
            CredButton.danger(
              title: 'Danger Button',
              onTap: () {
                Get.snackbar(
                  'Danger Button',
                  'You tapped the danger button',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: HeroIcons.exclamationTriangle,
            ),
            SizedBox(height: 16.h),
            
            // Outline Button
            CredButton.outline(
              title: 'Outline Button',
              onTap: () {
                Get.snackbar(
                  'Outline Button',
                  'You tapped the outline button',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            SizedBox(height: 16.h),
            
            // Loading Button
            CredButton.primary(
              title: 'Loading Button',
              onTap: () {},
              isLoading: true,
            ),
            
            SizedBox(height: 32.h),
            _buildSectionTitle('Cards', theme),
            SizedBox(height: 16.h),
            
            // Info Card
            CustomInfoCard(
              icon: HeroIcons.briefcase,
              title: 'Job Description',
              action: HeroIcons.pencil,
              onActionTap: () {
                Get.snackbar(
                  'Edit Job Description',
                  'You tapped the edit button',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Senior Flutter Developer',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'We are looking for a senior Flutter developer to join our team. The ideal candidate will have experience building high-quality mobile applications with Flutter.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      CustomTag(
                        icon: HeroIcons.briefcase,
                        title: 'Remote',
                      ),
                      CustomTag(
                        icon: HeroIcons.clock,
                        title: 'Full-time',
                      ),
                      CustomTag(
                        icon: HeroIcons.currencyDollar,
                        title: '\$100k-\$150k',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32.h),
            _buildSectionTitle('Text Fields', theme),
            SizedBox(height: 16.h),
            
            // Regular Text Field
            const CustomTextField(
              title: 'Email',
              hintText: 'Enter your email',
              isRequired: true,
            ),
            SizedBox(height: 16.h),
            
            // Password Text Field
            const CustomTextField(
              title: 'Password',
              hintText: 'Enter your password',
              isPassword: true,
              obscureText: true,
              suffixIcon: HeroIcons.eye,
            ),
            
            SizedBox(height: 32.h),
            _buildSectionTitle('Avatars', theme),
            SizedBox(height: 16.h),
            
            // Avatars
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomAvatar(
                  imageUrl: 'https://picsum.photos/200',
                  height: 60.h,
                ),
                CustomAvatar(
                  imageUrl: 'https://picsum.photos/200',
                  height: 40.h,
                ),
                CustomAvatar(
                  imageUrl: 'https://picsum.photos/200',
                  height: 30.h,
                ),
              ],
            ),
            
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  /// Build a section title
  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        title,
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
