import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/error/widgets/offline_widget.dart';
import 'package:next_gen/core/services/connectivity_service.dart';

/// A widget that shows different content based on network connectivity
class NetworkAwareWidget extends StatelessWidget {
  /// Creates a NetworkAwareWidget
  const NetworkAwareWidget({
    required this.onlineChild,
    this.offlineChild,
    this.loadingChild,
    this.showOfflineOnly = false,
    super.key,
  });

  /// Widget to show when online
  final Widget onlineChild;

  /// Widget to show when offline
  final Widget? offlineChild;

  /// Widget to show when checking connectivity
  final Widget? loadingChild;

  /// Whether to only show the offline widget when offline
  /// If true, the onlineChild will be shown regardless of connectivity
  /// and the offlineChild will be shown as an overlay when offline
  final bool showOfflineOnly;

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();

    return Obx(() {
      final status = connectivityService.status;

      // If we're only showing the offline widget when offline
      if (showOfflineOnly) {
        return Stack(
          children: [
            // Always show the online child
            onlineChild,

            // Show the offline widget as an overlay when offline
            if (status == ConnectivityStatus.offline)
              Positioned.fill(
                child: offlineChild ?? const OfflineWidget(),
              ),
          ],
        );
      }

      // Otherwise, show different widgets based on connectivity
      switch (status) {
        case ConnectivityStatus.online:
          return onlineChild;
        case ConnectivityStatus.offline:
          return offlineChild ?? const OfflineWidget();
        case ConnectivityStatus.unknown:
          return loadingChild ??
              const Center(
                child: CircularProgressIndicator(),
              );
      }
    });
  }
}
