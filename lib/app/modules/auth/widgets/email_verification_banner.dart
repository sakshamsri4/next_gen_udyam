import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';

/// A banner that reminds users to verify their email
class EmailVerificationBanner extends StatelessWidget {
  /// Creates an email verification banner
  const EmailVerificationBanner({
    this.onResendPressed,
    this.onDismissed,
    super.key,
  });

  /// Callback when the resend button is pressed
  final VoidCallback? onResendPressed;

  /// Callback when the banner is dismissed
  final VoidCallback? onDismissed;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.user.value;

    // Don't show the banner if the user is null or already verified
    if (user == null || user.emailVerified) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(51), // 0.2 * 255 = 51
        border: const Border(
          bottom: BorderSide(
            color: Colors.amber,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.amber,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Please verify your email',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Check your inbox and verify your email to access all features',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onResendPressed ?? authController.sendEmailVerification,
            style: TextButton.styleFrom(
              foregroundColor: Colors.amber.shade800,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('Resend'),
          ),
          if (onDismissed != null)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onDismissed,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              color: Colors.amber.shade800,
            ),
        ],
      ),
    );
  }
}
