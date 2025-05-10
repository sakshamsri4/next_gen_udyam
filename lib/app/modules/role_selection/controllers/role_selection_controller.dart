import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/auth/models/user_model.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/services/logger_service.dart';

/// Controller for the role selection screen
class RoleSelectionController extends GetxController {
  /// Get instance of RoleSelectionController
  static RoleSelectionController get to => Get.find();

  final AuthController _authController = Get.find<AuthController>();
  final AuthService _authService = Get.find<AuthService>();
  final LoggerService _logger = Get.find<LoggerService>();

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Selected role
  final Rx<UserType?> selectedRole = Rx<UserType?>(null);

  /// Check if continue button is enabled
  bool get isContinueEnabled => selectedRole.value != null && !isLoading.value;

  /// Set the selected role
  void setRole(UserType role) {
    selectedRole.value = role;
  }

  /// Continue with the selected role
  Future<void> continueWithRole() async {
    if (selectedRole.value == null) {
      Get.snackbar(
        'Error',
        'Please select a role to continue',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      _logger.i('Setting user role: ${selectedRole.value}');

      // Get current user
      final user = _authController.user.value;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Update user model with selected role
      final userModel = await _authService.getUserFromFirebase();
      if (userModel == null) {
        throw Exception('Failed to get user model');
      }

      // Update user profile with role
      final updatedUserModel = userModel.copyWith(
        userType: selectedRole.value,
      );

      // Save to Firestore
      await _authService.updateUserInFirestore(updatedUserModel);

      // Navigate to appropriate screen based on role
      if (selectedRole.value == UserType.employee) {
        await Get.offAllNamed<dynamic>(Routes.dashboard);
      } else {
        await Get.offAllNamed<dynamic>(Routes.dashboard);
      }
    } catch (e) {
      _logger.e('Error setting user role', e);
      Get.snackbar(
        'Error',
        'Failed to set user role. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
