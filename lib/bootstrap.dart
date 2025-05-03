// ignore_for_file: cascade_invocations

import 'dart:async';
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/core/di/service_locator.dart';
// Analytics service commented out for now, will be implemented later
// import 'package:next_gen/core/services/analytics_service.dart';
import 'package:next_gen/core/services/connectivity_service.dart';
import 'package:next_gen/core/services/error_service.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/theme/theme_controller.dart';
import 'package:next_gen/firebase_options.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // Use LoggerService if available, otherwise fallback to log
    try {
      Get.find<LoggerService>()
          .d('Bloc onChange(${bloc.runtimeType}, $change)');
    } catch (_) {
      dev.log('onChange(${bloc.runtimeType}, $change)');
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    // Use LoggerService if available, otherwise fallback to log
    try {
      Get.find<LoggerService>()
          .e('Bloc onError(${bloc.runtimeType})', error, stackTrace);
    } catch (_) {
      dev.log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    }
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase might already be initialized, which is fine
    debugPrint(
      'Firebase initialization issue (might be already initialized): $e',
    );
  }

  // Initialize all services using the service locator
  try {
    await initializeServices();
  } catch (e, s) {
    // If service initialization fails, log the error and continue
    // We'll use print since the logger might not be initialized yet
    debugPrint('Error initializing services: $e\n$s');

    // Try to initialize critical services individually
    try {
      // Ensure LoggerService is registered
      if (!serviceLocator.isRegistered<LoggerService>()) {
        serviceLocator.registerSingleton<LoggerService>(LoggerService());
        debugPrint('Registered LoggerService after initial failure');
      }

      // Ensure AuthService is registered
      if (!serviceLocator.isRegistered<AuthService>()) {
        serviceLocator.registerSingleton<AuthService>(AuthService());
        debugPrint('Registered AuthService after initial failure');
      }
    } catch (innerError) {
      debugPrint('Error during fallback service registration: $innerError');
    }
  }

  // Get the logger from the service locator
  final logger = serviceLocator<LoggerService>();
  logger.i('Bootstrap: Services initialized successfully');

  // Set up Flutter error handling
  FlutterError.onError = (details) {
    // Use LoggerService for Flutter errors
    logger.e('FlutterError caught', details.exception, details.stack);
  };

  // Set up BLoC observer
  Bloc.observer = const AppBlocObserver();
  logger.i('Bootstrap: BLoC observer set up');

  // Register services with GetX for backward compatibility
  _registerServicesWithGetX(logger);

  // Run the app
  logger.i('Bootstrap: Running app');
  runApp(await builder());
}

/// Register services with GetX for backward compatibility
void _registerServicesWithGetX(dynamic loggerDynamic) {
  final logger = loggerDynamic as LoggerService;
  logger.i('Registering services with GetX for backward compatibility');

  try {
    // Register LoggerService
    if (!Get.isRegistered<LoggerService>()) {
      Get.put(serviceLocator<LoggerService>(), permanent: true);
    }

    // Register ThemeController
    if (!Get.isRegistered<ThemeController>()) {
      Get.put(serviceLocator<ThemeController>(), permanent: true);
    }

    // Register ConnectivityService
    if (!Get.isRegistered<ConnectivityService>()) {
      Get.put(serviceLocator<ConnectivityService>(), permanent: true);
    }

    // Register ErrorService
    if (!Get.isRegistered<ErrorService>()) {
      Get.put(serviceLocator<ErrorService>(), permanent: true);
    }

    // Register AuthService
    if (!Get.isRegistered<AuthService>()) {
      Get.put(serviceLocator<AuthService>(), permanent: true);
    }

    // Analytics service commented out for now, will be implemented later
    /*
    if (!Get.isRegistered<AnalyticsService>()) {
      Get.put(serviceLocator<AnalyticsService>(), permanent: true);
    }
    */

    logger.i('All services registered with GetX successfully');
  } catch (e, s) {
    logger.e('Error registering services with GetX', e, s);
  }
}
