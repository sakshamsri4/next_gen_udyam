import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';

/// A custom avatar component for displaying profile images
///
/// This component handles loading, error states, and proper image caching
class CustomAvatar extends StatelessWidget {
  /// Creates a custom avatar
  ///
  /// [imageUrl] is the URL of the image to display
  /// [height] is the height of the avatar (width will be the same)
  /// [radius] is the border radius of the avatar
  const CustomAvatar({
    required this.imageUrl,
    super.key,
    this.height,
    this.radius,
  });

  final String imageUrl;
  final double? height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final avatarHeight = height ?? 80.h;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: avatarHeight,
      fit: BoxFit.contain,
      imageBuilder: (context, imageProvider) => ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 10000),
        child: Container(
          height: avatarHeight,
          width: avatarHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        height: avatarHeight,
        width: avatarHeight,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: avatarHeight,
        width: avatarHeight,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: Center(
          child: HeroIcon(
            HeroIcons.exclamationCircle,
            color: Colors.grey[500],
            size: 0.5 * avatarHeight,
          ),
        ),
      ),
    );
  }
}
