import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/core/services/connectivity_service.dart';

/// A widget that displays the current network status
class NetworkStatusWidget extends StatelessWidget {
  /// Creates a NetworkStatusWidget
  const NetworkStatusWidget({
    this.showOnlyWhenOffline = false,
    this.position = NetworkStatusPosition.top,
    super.key,
  });

  /// Whether to show the widget only when offline
  final bool showOnlyWhenOffline;

  /// The position of the widget
  final NetworkStatusPosition position;

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();

    return Obx(() {
      final status = connectivityService.status;

      // If we should only show when offline and we're online,
      // return empty container
      if (showOnlyWhenOffline && status == ConnectivityStatus.online) {
        return const SizedBox.shrink();
      }

      final isOnline = status == ConnectivityStatus.online;
      final backgroundColor = isOnline
          ? Colors.green.shade700
          : status == ConnectivityStatus.offline
              ? Colors.red.shade700
              : Colors.orange.shade700;

      final text = isOnline
          ? 'Online'
          : status == ConnectivityStatus.offline
              ? 'Offline'
              : 'Unknown Connection Status';

      final icon = isOnline
          ? Icons.wifi
          : status == ConnectivityStatus.offline
              ? Icons.wifi_off
              : Icons.wifi_find;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        color: backgroundColor,
        child: SafeArea(
          top: position == NetworkStatusPosition.top,
          bottom: position == NetworkStatusPosition.bottom,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isOnline) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: () async {
                    await connectivityService.checkConnection();
                  },
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}

/// The position of the network status widget
enum NetworkStatusPosition {
  /// Show at the top of the screen
  top,

  /// Show at the bottom of the screen
  bottom,
}
