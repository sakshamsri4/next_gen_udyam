import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/routes/app_pages.dart';

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Get the auth controller
    final authController = Get.find<AuthController>();

    // If the user is not logged in, redirect to auth page
    if (authController.user.value == null) {
      return const RouteSettings(name: Routes.login);
    }

    return null;
  }
}
