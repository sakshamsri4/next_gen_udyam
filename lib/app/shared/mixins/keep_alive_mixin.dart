import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A mixin that provides state preservation for tab views
///
/// This mixin combines Flutter's AutomaticKeepAliveClientMixin with GetX's
/// state management to ensure that tab views preserve their state when
/// switching between tabs.
///
/// Usage:
/// ```dart
/// class MyTabView extends GetView<MyController> with KeepAliveMixin {
///   const MyTabView({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     // Must call super.build to enable keep alive functionality
///     super.build(context);
///
///     return YourWidget();
///   }
/// }
/// ```
mixin KeepAliveMixin<T extends StatefulWidget> on State<T>
    implements AutomaticKeepAliveClientMixin<T> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // This super call is required to enable the keep alive functionality
    super.build(context);
    return const SizedBox.shrink(); // Placeholder, should be overridden
  }
}

/// A mixin that provides state preservation for GetView tab views
///
/// This mixin combines Flutter's AutomaticKeepAliveClientMixin with GetX's
/// GetView to ensure that tab views preserve their state when switching
/// between tabs.
///
/// Usage:
/// ```dart
/// class MyTabView extends GetView<MyController> with GetViewKeepAliveMixin {
///   const MyTabView({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     // Must call super.build to enable keep alive functionality
///     super.build(context);
///
///     return YourWidget();
///   }
/// }
/// ```
mixin GetViewKeepAliveMixin<T> on GetView<T> {
  /// The state key for this view
  final _stateKey = GlobalKey<_GetViewKeepAliveState>();

  @override
  Widget build(BuildContext context) {
    return _GetViewKeepAlive(
      key: _stateKey,
      child: buildContent(context),
    );
  }

  /// Build the content of the view
  ///
  /// This method should be implemented by the class that uses this mixin
  /// to provide the actual content of the view.
  Widget buildContent(BuildContext context);
}

/// A stateful widget that wraps a GetView to provide keep alive functionality
class _GetViewKeepAlive extends StatefulWidget {
  /// Creates a keep alive wrapper for a GetView
  const _GetViewKeepAlive({
    required this.child,
    super.key,
  });

  /// The child widget to keep alive
  final Widget child;

  @override
  State<_GetViewKeepAlive> createState() => _GetViewKeepAliveState();
}

class _GetViewKeepAliveState extends State<_GetViewKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
