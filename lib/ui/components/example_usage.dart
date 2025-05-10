import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/ui/components/avatars/custom_avatar.dart';
import 'package:next_gen/ui/components/buttons/button_with_text.dart';
import 'package:next_gen/ui/components/buttons/custom_button.dart';
import 'package:next_gen/ui/components/buttons/custom_save_button.dart';
import 'package:next_gen/ui/components/cards/custom_info_card.dart';
import 'package:next_gen/ui/components/cards/custom_job_card.dart';
import 'package:next_gen/ui/components/cards/custom_tag.dart';
import 'package:next_gen/ui/components/fields/custom_text_field.dart';
import 'package:next_gen/ui/components/loaders/custom_lottie.dart';
import 'package:next_gen/ui/components/loaders/shimmer/featured_job_shimmer.dart';
import 'package:next_gen/ui/components/loaders/shimmer/recent_jobs_shimmer.dart';

/// Example usage of the UI components
///
/// This widget demonstrates how to use the UI components
class ComponentExamples extends StatelessWidget {
  /// Creates a component examples widget
  const ComponentExamples({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Components'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buttons
            _buildSectionTitle('Buttons', theme),
            CustomButton(
              title: 'Primary Button',
              onTap: () async {
                await Future<void>.delayed(const Duration(seconds: 1));
              },
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                CustomSaveButton(
                  isLiked: true,
                  onTap: ({required bool isLiked}) async {
                    await Future<void>.delayed(const Duration(seconds: 1));
                    return !isLiked;
                  },
                ),
                SizedBox(width: 16.w),
                CustomSaveButton(
                  onTap: ({required bool isLiked}) async {
                    await Future<void>.delayed(const Duration(seconds: 1));
                    return !isLiked;
                  },
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ButtonWithText(
              btnLabel: 'Sign Up',
              firstTextSpan: 'Already have an account? ',
              secondTextSpan: 'Login',
              onTap: () async {
                await Future<void>.delayed(const Duration(seconds: 1));
              },
              onTextTap: () {},
            ),

            // Text Fields
            SizedBox(height: 32.h),
            _buildSectionTitle('Text Fields', theme),
            const CustomTextField(
              title: 'Email',
              hintText: 'Enter your email',
              isRequired: true,
            ),
            SizedBox(height: 16.h),
            const CustomTextField(
              title: 'Password',
              hintText: 'Enter your password',
              isPassword: true,
              obscureText: true,
              suffixIcon: HeroIcons.eye,
            ),
            SizedBox(height: 16.h),
            // SearchBar(
            //   controller: TextEditingController(),
            //   hintText: 'Search for jobs...',
            //   onChanged: (value) {},
            //   onClear: () {},
            // ),

            // Cards
            SizedBox(height: 32.h),
            _buildSectionTitle('Cards', theme),
            CustomJobCard(
              avatar: 'https://picsum.photos/200',
              companyName: 'Google',
              publishTime: '2023-07-20T12:00:00Z',
              jobPosition: 'Senior Flutter Developer',
              workplace: 'Remote',
              employmentType: 'Full-time',
              location: 'New York',
              actionIcon: HeroIcons.bookmark,
              description: 'We are looking for a senior Flutter developer '
                  'to join our team.',
              onActionTap: ({required bool isLiked}) async {
                await Future<void>.delayed(const Duration(seconds: 1));
                return !isLiked;
              },
            ),
            SizedBox(height: 16.h),
            const CustomJobCard(
              avatar: 'https://picsum.photos/200',
              companyName: 'Facebook',
              publishTime: '2023-07-19T12:00:00Z',
              jobPosition: 'Flutter Developer',
              workplace: 'On-site',
              employmentType: 'Full-time',
              location: 'San Francisco',
              actionIcon: HeroIcons.bookmark,
              isFeatured: true,
            ),
            SizedBox(height: 16.h),
            CustomInfoCard(
              icon: HeroIcons.briefcase,
              title: 'Job Description',
              child: Text(
                'We are looking for a Flutter developer to join our team.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                CustomTag(
                  icon: HeroIcons.briefcase,
                  title: 'Remote',
                  backgroundColor: theme.colorScheme.surface,
                  titleColor: theme.colorScheme.secondary,
                ),
                CustomTag(
                  icon: HeroIcons.fire,
                  title: 'Full-time',
                  backgroundColor: theme.colorScheme.surface,
                  titleColor: theme.colorScheme.secondary,
                ),
                CustomTag(
                  icon: HeroIcons.mapPin,
                  title: 'New York',
                  backgroundColor: theme.colorScheme.surface,
                  titleColor: theme.colorScheme.secondary,
                ),
              ],
            ),

            // Avatars
            SizedBox(height: 32.h),
            _buildSectionTitle('Avatars', theme),
            Row(
              children: [
                CustomAvatar(
                  imageUrl: 'https://picsum.photos/200',
                  height: 60.h,
                ),
                SizedBox(width: 16.w),
                CustomAvatar(
                  imageUrl: 'https://picsum.photos/200',
                  height: 40.h,
                ),
                SizedBox(width: 16.w),
                CustomAvatar(
                  imageUrl: 'https://invalid-url.com/image.jpg',
                  height: 40.h,
                ),
              ],
            ),

            // Loaders
            SizedBox(height: 32.h),
            _buildSectionTitle('Loaders', theme),
            SizedBox(
              height: 200.h,
              child: CustomLottie(
                title: 'No results found',
                asset: 'assets/lottie/empty.json',
                description: 'Try adjusting your search',
                assetHeight: 100.h,
              ),
            ),
            SizedBox(height: 16.h),
            _buildSectionTitle('Shimmers', theme),
            const FeaturedJobShimmer(),
            SizedBox(height: 16.h),
            SizedBox(
              height: 200.h,
              child: const RecentJobsShimmer(),
            ),
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
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
