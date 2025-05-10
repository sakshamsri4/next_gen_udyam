import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

/// A custom save/bookmark button with loading and toggled states
///
/// This button shows a loading indicator when the async action is in progress
/// and toggles between filled and outlined bookmark icons
class CustomSaveButton extends StatefulWidget {
  /// Creates a custom save button
  ///
  /// [size] is the size of the button
  /// [isLiked] is whether the item is saved/liked
  /// [onTap] is the async function to call when the button is tapped
  /// [color] is the color of the button
  const CustomSaveButton({
    super.key,
    this.size = 24.0,
    this.isLiked = false,
    this.onTap,
    this.color = Colors.blue,
  });

  /// The size of the button
  final double size;

  /// The color of the button
  final Color color;

  /// The async function to call when the button is tapped
  /// Returns the new liked state
  final Future<bool?> Function({required bool isLiked})? onTap;

  /// Whether the item is saved/liked
  final bool isLiked;

  @override
  State<StatefulWidget> createState() => CustomSaveButtonState();
}

/// The state for the CustomSaveButton
class CustomSaveButtonState extends State<CustomSaveButton>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  /// Whether the item is saved/liked
  bool _isLiked = false;

  /// Getter for the saved/liked state
  bool get isLiked => _isLiked;

  /// Whether the button is in loading state
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _isLiked = widget.isLiked;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(CustomSaveButton oldWidget) {
    _isLiked = widget.isLiked;

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: isLoading ? null : onTap,
      child: isLoading
          ? SizedBox(
              height: widget.size,
              width: widget.size,
              child: Center(
                child: CupertinoActivityIndicator(
                  color: widget.color,
                ),
              ),
            )
          : HeroIcon(
              HeroIcons.bookmark,
              style: _isLiked ? HeroIconStyle.solid : HeroIconStyle.outline,
              size: widget.size,
              color: widget.color,
            ),
    );
  }

  /// Handle the tap event
  void onTap() {
    setState(() {
      isLoading = true;
    });
    if (widget.onTap != null) {
      widget.onTap!(isLiked: _isLiked).then(_handleIsLikeChanged);
    } else {
      _handleIsLikeChanged(!_isLiked);
    }
  }

  /// Handle the change in liked state
  void _handleIsLikeChanged(bool? isLiked) {
    if (isLiked != null && isLiked != _isLiked) {
      _isLiked = isLiked;
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        setState(() {
          if (_isLiked) {
            _controller!.reset();
            _controller!.forward();
          }
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
