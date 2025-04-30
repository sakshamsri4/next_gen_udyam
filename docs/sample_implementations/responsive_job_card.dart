import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:neopop/neopop.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// A responsive job card that adapts to different screen sizes.
///
/// This card combines NeoPOP styling with responsive design to provide
/// a consistent experience across different devices and screen sizes.
class ResponsiveJobCard extends StatelessWidget {
  /// Creates a ResponsiveJobCard.
  const ResponsiveJobCard({
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.onTap,
    this.logoUrl,
    this.postedDate,
    this.tags = const [],
    this.isFeatured = false,
    this.onSave,
    this.onApply,
    this.onShare,
    this.isNew = false,
    super.key,
  });

  /// The job title.
  final String title;

  /// The company name.
  final String company;

  /// The job location.
  final String location;

  /// The job salary.
  final String salary;

  /// The callback that is called when the card is tapped.
  final VoidCallback onTap;

  /// The URL of the company logo.
  final String? logoUrl;

  /// The date when the job was posted.
  final String? postedDate;

  /// The tags associated with the job.
  final List<String> tags;

  /// Whether the job is featured.
  final bool isFeatured;

  /// The callback that is called when the save action is triggered.
  final VoidCallback? onSave;

  /// The callback that is called when the apply action is triggered.
  final VoidCallback? onApply;

  /// The callback that is called when the share action is triggered.
  final VoidCallback? onShare;

  /// Whether the job is new.
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // Use different layouts based on screen size
        switch (sizingInformation.deviceScreenType) {
          case DeviceScreenType.desktop:
            return _buildDesktopCard(context);
          case DeviceScreenType.tablet:
            return _buildTabletCard(context);
          case DeviceScreenType.mobile:
          default:
            return _buildMobileCard(context);
        }
      },
    );
  }

  /// Builds the card for desktop screens.
  Widget _buildDesktopCard(BuildContext context) {
    return Slidable(
      key: key,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (onSave != null)
            SlidableAction(
              onPressed: (_) => onSave!(),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.bookmark,
              label: 'Save',
            ),
          if (onApply != null)
            SlidableAction(
              onPressed: (_) => onApply!(),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.check_circle,
              label: 'Apply',
            ),
          if (onShare != null)
            SlidableAction(
              onPressed: (_) => onShare!(),
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
            ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: NeoPopCard(
          color: Theme.of(context).cardColor,
          depth: isFeatured ? 5 : 3,
          parentColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company logo
                if (logoUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: logoUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.business),
                      ),
                    ),
                  ),
                const SizedBox(width: 16),
                // Job details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.titleLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isNew)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ).animate().fadeIn().slideX(),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        company,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.attach_money, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            salary,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                // Posted date
                if (postedDate != null)
                  Text(
                    postedDate!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  /// Builds the card for tablet screens.
  Widget _buildTabletCard(BuildContext context) {
    // Similar to desktop but with adjusted spacing and font sizes
    return Slidable(
      key: key,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (onSave != null)
            SlidableAction(
              onPressed: (_) => onSave!(),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.bookmark,
              label: 'Save',
            ),
          if (onApply != null)
            SlidableAction(
              onPressed: (_) => onApply!(),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.check_circle,
              label: 'Apply',
            ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: NeoPopCard(
          color: Theme.of(context).cardColor,
          depth: isFeatured ? 4 : 2,
          parentColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company logo
                if (logoUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: logoUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.business),
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                // Job details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isNew)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ).animate().fadeIn().slideX(),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        company,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.attach_money, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            salary,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.05, end: 0);
  }

  /// Builds the card for mobile screens.
  Widget _buildMobileCard(BuildContext context) {
    return Slidable(
      key: key,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (onSave != null)
            SlidableAction(
              onPressed: (_) => onSave!(),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.bookmark,
            ),
          if (onApply != null)
            SlidableAction(
              onPressed: (_) => onApply!(),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.check_circle,
            ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: NeoPopCard(
          color: Theme.of(context).cardColor,
          depth: isFeatured ? 3 : 1.5,
          parentColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and logo
                Row(
                  children: [
                    if (logoUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: logoUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey[300],
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey[300],
                            child: const Icon(Icons.business, size: 20),
                          ),
                        ),
                      ),
                    if (logoUrl != null) const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            company,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    if (isNew)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ).animate().fadeIn().slideX(),
                  ],
                ),
                const SizedBox(height: 8),
                // Location and salary
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.attach_money, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      salary,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                // Posted date
                if (postedDate != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        postedDate!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.03, end: 0);
  }
}

/// Example usage:
///
/// ```dart
/// ResponsiveJobCard(
///   title: 'Flutter Developer',
///   company: 'Tech Solutions Inc.',
///   location: 'New York, NY',
///   salary: '$80K - $120K',
///   logoUrl: 'https://example.com/logo.png',
///   postedDate: '2 days ago',
///   tags: ['Flutter', 'Dart', 'Mobile'],
///   isFeatured: true,
///   isNew: true,
///   onTap: () => print('Job card tapped'),
///   onSave: () => print('Save job'),
///   onApply: () => print('Apply for job'),
///   onShare: () => print('Share job'),
/// )
/// ```
