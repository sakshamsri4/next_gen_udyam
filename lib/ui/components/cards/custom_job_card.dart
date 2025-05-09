import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

import 'package:next_gen/ui/components/avatars/custom_avatar.dart';
import 'package:next_gen/ui/components/buttons/custom_save_button.dart';
import 'package:next_gen/ui/components/cards/custom_tag.dart';

/// A custom card for displaying job information
///
/// This card displays job details including company info, position,
/// description, and tags for workplace, employment type, and location
class CustomJobCard extends StatelessWidget {
  /// Creates a custom job card
  ///
  /// [avatar] is the URL of the company logo
  /// [companyName] is the name of the company
  /// [publishTime] is the time the job was published (ISO 8601 format)
  /// [jobPosition] is the job title/position
  /// [workplace] is the workplace type (e.g., Remote, On-site)
  /// [employmentType] is the type of employment (e.g., Full-time, Part-time)
  /// [location] is the job location
  /// [actionIcon] is the icon for the action button
  /// [isFeatured] indicates if this is a featured job
  /// [description] is the job description
  /// [isSaved] indicates if the job is saved
  /// [onAvatarTap] is called when the avatar is tapped
  /// [onActionTap] is called when the action button is tapped
  /// [onTap] is called when the card is tapped
  const CustomJobCard({
    required this.avatar,
    required this.companyName,
    required this.publishTime,
    required this.jobPosition,
    required this.workplace,
    required this.employmentType,
    required this.location,
    required this.actionIcon,
    super.key,
    this.isFeatured = false,
    this.onAvatarTap,
    this.description,
    this.onActionTap,
    this.onTap,
    this.isSaved = false,
  });

  final bool isFeatured;
  final String avatar;
  final String companyName;
  final String publishTime;
  final String jobPosition;
  final String workplace;
  final String employmentType;
  final String location;
  final String? description;
  final HeroIcons actionIcon;
  final bool isSaved;
  final void Function()? onAvatarTap;
  final Future<bool?> Function({required bool isLiked})? onActionTap;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final datetime = DateTime.parse(publishTime);
    final strDate = DateFormat.yMMMMd().format(datetime);

    final cardPadding = 20.w;
    final cardMarginH = 16.w;
    final cardMarginV = 16.h;
    final cardRadius = 14.r;
    final spacingHeight = 8.h;

    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        margin: EdgeInsets.only(
          right: cardMarginH,
          left: cardMarginH,
          bottom: cardMarginV,
        ),
        decoration: BoxDecoration(
          color: isFeatured ? theme.colorScheme.secondary : Colors.white,
          borderRadius: BorderRadius.circular(cardRadius),
          gradient: isFeatured
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary,
                  ],
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: isFeatured
                  ? theme.primaryColor.withAlpha(38)
                  : Colors.grey.withAlpha(13),
              blurRadius: isFeatured ? 10 : 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _CardTile(
              isFeatured: isFeatured,
              avatar: avatar,
              companyName: companyName,
              publishTime: strDate,
              onAvatarTap: onAvatarTap,
              onActionTap: onActionTap,
              actionIcon: actionIcon,
              isSaved: isSaved,
            ),
            SizedBox(height: spacingHeight),
            _CardJobPosition(
              isFeatured: isFeatured,
              jobPosition: jobPosition,
            ),
            if (!isFeatured) SizedBox(height: 5.h),
            if (!isFeatured && description != null)
              _CardJobDescription(description: description!),
            SizedBox(height: spacingHeight),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: _CardTags(
                isFeatured: isFeatured,
                employmentType: employmentType,
                location: location,
                workplace: workplace,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Company name, avatar, published time, and save button
class _CardTile extends StatelessWidget {
  const _CardTile({
    required this.isFeatured,
    required this.avatar,
    required this.companyName,
    required this.publishTime,
    required this.actionIcon,
    required this.isSaved,
    this.onAvatarTap,
    this.onActionTap,
  });

  final bool isFeatured;
  final String avatar;
  final String companyName;
  final String publishTime;
  final void Function()? onAvatarTap;
  final Future<bool?> Function({required bool isLiked})? onActionTap;
  final HeroIcons actionIcon;
  final bool isSaved;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = 13.sp;
    final iconSize = 16.w;
    final avatarHeight = 46.h;
    final spacing = 5.w;
    final buttonSize = 24.w;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onAvatarTap ?? () {},
          child: CustomAvatar(
            imageUrl: avatar,
            height: avatarHeight,
          ),
        ),
        SizedBox(width: spacing),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              companyName,
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: isFeatured
                    ? theme.colorScheme.surface
                    : theme.colorScheme.onSurface,
              ),
            ),
            Row(
              children: [
                HeroIcon(
                  HeroIcons.clock,
                  size: iconSize,
                  color: isFeatured
                      ? theme.colorScheme.surface
                      : theme.colorScheme.secondary,
                ),
                SizedBox(width: spacing),
                Text(
                  publishTime,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                    color: isFeatured
                        ? theme.colorScheme.surface
                        : theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        CustomSaveButton(
          onTap: onActionTap,
          isLiked: isSaved,
          size: buttonSize,
          color: isFeatured
              ? theme.colorScheme.surface
              : theme.colorScheme.secondary,
        ),
      ],
    );
  }
}

/// Job position text
class _CardJobPosition extends StatelessWidget {
  const _CardJobPosition({
    required this.isFeatured,
    required this.jobPosition,
  });

  final bool isFeatured;
  final String jobPosition;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        jobPosition,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: isFeatured
              ? theme.colorScheme.surface
              : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

/// Job description text
class _CardJobDescription extends StatelessWidget {
  const _CardJobDescription({
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = 13.sp;

    return Text(
      description,
      overflow: TextOverflow.ellipsis,
      maxLines: 5,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: theme.colorScheme.onSurface.withAlpha(191),
      ),
    );
  }
}

/// Job tags (workplace, employment type, location)
class _CardTags extends StatelessWidget {
  const _CardTags({
    required this.isFeatured,
    required this.workplace,
    required this.employmentType,
    required this.location,
  });

  final bool isFeatured;
  final String workplace;
  final String employmentType;
  final String location;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CustomTag(
          title: workplace,
          icon: HeroIcons.briefcase,
          backgroundColor: isFeatured
              ? Colors.white.withAlpha(38)
              : theme.colorScheme.surface,
          titleColor: isFeatured
              ? theme.colorScheme.surface
              : theme.colorScheme.secondary,
        ),
        CustomTag(
          title: employmentType,
          icon: HeroIcons.fire,
          backgroundColor: isFeatured
              ? Colors.white.withAlpha(38)
              : theme.colorScheme.surface,
          titleColor: isFeatured
              ? theme.colorScheme.surface
              : theme.colorScheme.secondary,
        ),
        CustomTag(
          title: location,
          icon: HeroIcons.mapPin,
          backgroundColor: isFeatured
              ? Colors.white.withAlpha(38)
              : theme.colorScheme.surface,
          titleColor: isFeatured
              ? theme.colorScheme.surface
              : theme.colorScheme.secondary,
        ),
      ],
    );
  }
}
