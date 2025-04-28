import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/bindings/auth_binding.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/storage/storage_service.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/core/theme/theme_controller.dart';
import 'package:next_gen/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    // Failed to initialize Firebase
    debugPrint('Firebase initialization error: $e');
  }

  // Initialize Hive
  await StorageService.init();

  // Initialize controllers
  Get.put(ThemeController());

  // Initialize auth binding
  AuthBinding().dependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;

    return GetMaterialApp(
      title: 'Next Gen Job Portal',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppPages.initialRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
    );
  }
}
