import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';
import 'package:next_gen/app/modules/error/bindings/error_binding.dart';
import 'package:next_gen/app/routes/app_pages.dart';
import 'package:next_gen/core/di/service_locator.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/hive_manager.dart';
import 'package:next_gen/core/storage/storage_service.dart';
import 'package:next_gen/core/theme/app_theme.dart';
import 'package:next_gen/core/theme/theme_controller.dart';
import 'package:next_gen/core/utils/global_error_handler.dart';

import 'package:next_gen/l10n/l10n.dart';

/// Main application widget
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // Create a dedicated navigator key for this app instance
  final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'AppNavigatorKey');

  @override
  void initState() {
    super.initState();

    // Log initialization
    final logger = Get.find<LoggerService>()
      ..i('App widget initialized with unique navigator key');

    // Initialize error handling
    try {
      // Ensure error services are registered
      ErrorBinding().dependencies();

      // Initialize global error handler
      GlobalErrorHandler.init();
      logger.i('Global error handler initialized');
    } catch (e, s) {
      logger.e('Failed to initialize error handling', e, s);
    }
  }

  @override
  Widget build(BuildContext context) {
    final logger = Get.find<LoggerService>()..i('Building App widget');

    // Ensure HiveManager is registered first
    try {
      Get.find<HiveManager>();
      logger.d('HiveManager already registered');
    } catch (e) {
      logger.i('Pre-registering HiveManager');
      Get.put(serviceLocator<HiveManager>(), permanent: true);
    }

    // Ensure StorageService is registered after HiveManager
    try {
      Get.find<StorageService>();
      logger.d('StorageService already registered');
    } catch (e) {
      logger.i('Pre-registering StorageService');
      Get.put(serviceLocator<StorageService>(), permanent: true);
    }

    // Try to get the theme controller that was initialized in bootstrap.dart
    // If it's not available, initialize it here
    ThemeController themeController;
    try {
      themeController = Get.find<ThemeController>();
      logger.d('ThemeController found');
    } catch (e) {
      // If ThemeController is not found, initialize it
      logger.w('ThemeController not found, initializing it now');
      themeController = Get.put(ThemeController(), permanent: true);
    }

    // Pre-register AuthController to avoid middleware issues
    try {
      Get.find<AuthController>();
      logger.d('AuthController already registered');
    } catch (e) {
      logger.i('Pre-registering AuthController');
      Get.put(AuthController(), permanent: true);
    }

    // Initialize ScreenUtil before any widgets that use it
    // Ensure ScreenUtil is initialized synchronously to prevent LateInitializationError
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
    );

    return ScreenUtilInit(
      // Design size based on standard mobile device dimensions
      designSize: const Size(375, 812),
      // Ensure ScreenUtil works properly in split screen mode
      splitScreenMode: true,
      // Use minimal text scaling to maintain design integrity
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Next Gen Job Portal',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // Use our dedicated navigator key
          navigatorKey: _navigatorKey,
          // Ensure proper navigation history management
          navigatorObservers: [GetObserver()],
          // Prevent nested navigators from using the same key
          useInheritedMediaQuery: true,
        );
      },
    );
  }
}
