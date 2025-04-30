import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Get the auth controller
    final authController = Get.find<AuthController>();

    // If the user is logged in, redirect to home
    // Otherwise, continue to the auth page
    if (authController.isLoggedIn.value) {
      return const RouteSettings(name: Routes.home);
    }

    return null;
  }
}
