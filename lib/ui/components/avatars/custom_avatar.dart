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
  /// [width] is the width of the avatar (if different from height)
  /// [radius] is the border radius of the avatar
  /// [placeholderText] is the text to display when no image is available
  const CustomAvatar({
    required this.imageUrl,
    super.key,
    this.height,
    this.width,
    this.radius,
    this.placeholderText,
  });

  /// The URL of the image to display
  final String imageUrl;

  /// The height of the avatar
  final double? height;

  /// The width of the avatar
  final double? width;

  /// The border radius of the avatar
  final double? radius;

  /// The text to display when no image is available
  final String? placeholderText;

  @override
  Widget build(BuildContext context) {
    final avatarHeight = height ?? 80.h;
    final avatarWidth = width ?? avatarHeight;

    // If the image URL is empty, show a placeholder
    if (imageUrl.isEmpty) {
      return Container(
        height: avatarHeight,
        width: avatarWidth,
        decoration: BoxDecoration(
          shape: BorderRadius.circular(radius ?? 10000) ==
                  BorderRadius.circular(10000)
              ? BoxShape.circle
              : BoxShape.rectangle,
          borderRadius: BorderRadius.circular(radius ?? 10000) !=
                  BorderRadius.circular(10000)
              ? BorderRadius.circular(radius ?? 10000)
              : null,
          color: Colors.grey[300],
        ),
        child: Center(
          child: placeholderText != null
              ? Text(
                  placeholderText!,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: avatarHeight * 0.4,
                  ),
                )
              : HeroIcon(
                  HeroIcons.user,
                  color: Colors.grey[500],
                  size: 0.5 * avatarHeight,
                ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: avatarHeight,
      width: avatarWidth,
      fit: BoxFit.cover,
      imageBuilder: (context, imageProvider) => ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 10000),
        child: Container(
          height: avatarHeight,
          width: avatarWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        height: avatarHeight,
        width: avatarWidth,
        decoration: BoxDecoration(
          shape: BorderRadius.circular(radius ?? 10000) ==
                  BorderRadius.circular(10000)
              ? BoxShape.circle
              : BoxShape.rectangle,
          borderRadius: BorderRadius.circular(radius ?? 10000) !=
                  BorderRadius.circular(10000)
              ? BorderRadius.circular(radius ?? 10000)
              : null,
          color: Colors.grey[300],
        ),
        child: Center(
          child: placeholderText != null
              ? Text(
                  placeholderText!,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: avatarHeight * 0.4,
                  ),
                )
              : const CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: avatarHeight,
        width: avatarWidth,
        decoration: BoxDecoration(
          shape: BorderRadius.circular(radius ?? 10000) ==
                  BorderRadius.circular(10000)
              ? BoxShape.circle
              : BoxShape.rectangle,
          borderRadius: BorderRadius.circular(radius ?? 10000) !=
                  BorderRadius.circular(10000)
              ? BorderRadius.circular(radius ?? 10000)
              : null,
          color: Colors.grey[300],
        ),
        child: Center(
          child: placeholderText != null
              ? Text(
                  placeholderText!,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: avatarHeight * 0.4,
                  ),
                )
              : HeroIcon(
                  HeroIcons.exclamationCircle,
                  color: Colors.grey[500],
                  size: 0.5 * avatarHeight,
                ),
        ),
      ),
    );
  }
}
