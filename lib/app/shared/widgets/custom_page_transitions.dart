import 'package:flutter/material.dart';

/// Custom page transitions for the app
class CustomPageTransitions {
  /// Private constructor to prevent instantiation
  CustomPageTransitions._();

  /// Fade transition
  static Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Slide transition from right
  static Widget slideRightTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1, 0);
    const end = Offset.zero;
    const curve = Curves.easeInOutCubic;

    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  /// Slide transition from left
  static Widget slideLeftTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(-1, 0);
    const end = Offset.zero;
    const curve = Curves.easeInOutCubic;

    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  /// Slide transition from bottom
  static Widget slideUpTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0, 1);
    const end = Offset.zero;
    const curve = Curves.easeInOutCubic;

    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  /// Scale transition
  static Widget scaleTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const curve = Curves.easeInOutCubic;
    final scaleTween =
        Tween<double>(begin: 0.8, end: 1).chain(CurveTween(curve: curve));
    final opacityTween =
        Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: curve));

    return ScaleTransition(
      scale: animation.drive(scaleTween),
      child: FadeTransition(
        opacity: animation.drive(opacityTween),
        child: child,
      ),
    );
  }

  /// Fade through transition (fade out current page while fading in new page)
  static Widget fadeThroughTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: FadeTransition(
        opacity: ReverseAnimation(secondaryAnimation),
        child: child,
      ),
    );
  }

  /// Shared axis transition (horizontal)
  static Widget sharedAxisHorizontalTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1, 0);
    const end = Offset.zero;
    const curve = Curves.easeInOutCubic;

    final primaryTween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    final secondaryTween = Tween(begin: const Offset(-0.3, 0), end: end)
        .chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(primaryTween),
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: secondaryAnimation.drive(secondaryTween),
          child: FadeTransition(
            opacity: ReverseAnimation(secondaryAnimation),
            child: child,
          ),
        ),
      ),
    );
  }
}
