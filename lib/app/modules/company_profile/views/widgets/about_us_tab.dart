import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:next_gen/app/modules/company_profile/models/company_profile_model.dart';
import 'package:url_launcher/url_launcher.dart';

/// The About Us tab for the company profile
class AboutUsTab extends StatelessWidget {
  /// Creates a new About Us tab
  const AboutUsTab({
    required this.profile,
    super.key,
  });

  /// The company profile
  final CompanyProfileModel profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company description
          if (profile.description != null && profile.description!.isNotEmpty)
            _buildDescriptionSection(theme),

          SizedBox(height: 24.h),

          // Company details
          _buildCompanyDetailsSection(theme),

          SizedBox(height: 24.h),

          // Social links
          if (profile.socialLinks.isNotEmpty) _buildSocialLinksSection(theme),

          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  /// Build the description section
  Widget _buildDescriptionSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Us',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          profile.description!,
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }

  /// Build the company details section
  Widget _buildCompanyDetailsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Company Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                // Website
                if (profile.website != null && profile.website!.isNotEmpty)
                  _buildDetailRow(
                    theme,
                    HeroIcons.globeAlt,
                    'Website',
                    profile.website!,
                    isLink: true,
                  ),

                // Industry
                if (profile.industry != null && profile.industry!.isNotEmpty)
                  _buildDetailRow(
                    theme,
                    HeroIcons.buildingOffice2,
                    'Industry',
                    profile.industry!,
                  ),

                // Company size
                if (profile.size != null && profile.size!.isNotEmpty)
                  _buildDetailRow(
                    theme,
                    HeroIcons.users,
                    'Company Size',
                    profile.size!,
                  ),

                // Founded
                if (profile.founded != null)
                  _buildDetailRow(
                    theme,
                    HeroIcons.calendar,
                    'Founded',
                    profile.founded.toString(),
                  ),

                // Location
                if (profile.location != null && profile.location!.isNotEmpty)
                  _buildDetailRow(
                    theme,
                    HeroIcons.mapPin,
                    'Location',
                    profile.location!,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build the social links section
  Widget _buildSocialLinksSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connect With Us',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          children: profile.socialLinks.entries.map((entry) {
            return _buildSocialButton(theme, entry.key, entry.value);
          }).toList(),
        ),
      ],
    );
  }

  /// Build a detail row
  Widget _buildDetailRow(
    ThemeData theme,
    HeroIcons icon,
    String label,
    String value, {
    bool isLink = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroIcon(
            icon,
            color: theme.colorScheme.primary,
            size: 20.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withAlpha(153), // 0.6 opacity
                  ),
                ),
                SizedBox(height: 2.h),
                if (isLink)
                  GestureDetector(
                    onTap: () => _launchUrl(value),
                    child: Text(
                      value,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                else
                  Text(
                    value,
                    style: theme.textTheme.bodyLarge,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build a social button
  Widget _buildSocialButton(ThemeData theme, String platform, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withAlpha(26), // 0.1 opacity
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getSocialIcon(theme, platform),
            SizedBox(width: 8.w),
            Text(
              _getSocialPlatformName(platform),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get the social platform icon
  Widget _getSocialIcon(ThemeData theme, String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return Icon(
          Icons.facebook,
          color: theme.colorScheme.primary,
          size: 20.r,
        );
      case 'twitter':
      case 'x':
        return Icon(
          Icons.flutter_dash,
          color: theme.colorScheme.primary,
          size: 20.r,
        );
      case 'linkedin':
        return Icon(
          Icons.link,
          color: theme.colorScheme.primary,
          size: 20.r,
        );
      case 'instagram':
        return Icon(
          Icons.camera_alt,
          color: theme.colorScheme.primary,
          size: 20.r,
        );
      default:
        return Icon(
          Icons.link,
          color: theme.colorScheme.primary,
          size: 20.r,
        );
    }
  }

  /// Get the social platform name
  String _getSocialPlatformName(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return 'Facebook';
      case 'twitter':
        return 'Twitter';
      case 'x':
        return 'X';
      case 'linkedin':
        return 'LinkedIn';
      case 'instagram':
        return 'Instagram';
      default:
        return platform;
    }
  }

  /// Launch a URL
  Future<void> _launchUrl(String urlString) async {
    var finalUrl = urlString;
    if (!urlString.startsWith('http://') && !urlString.startsWith('https://')) {
      finalUrl = 'https://$urlString';
    }

    final uri = Uri.parse(finalUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
