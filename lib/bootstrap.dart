// ignore_for_file: cascade_invocations

import 'dart:async';
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/core/di/service_locator.dart';
import 'package:next_gen/core/firebase/firebase_initializer.dart';
// Analytics service commented out for now, will be implemented later
// import 'package:next_gen/core/services/analytics_service.dart';
import 'package:next_gen/core/services/connectivity_service.dart';
import 'package:next_gen/core/services/error_service.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/hive_manager.dart';
import 'package:next_gen/core/storage/storage_service.dart';
import 'package:next_gen/core/theme/theme_controller.dart';

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
  // Note: WidgetsFlutterBinding.ensureInitialized() is already called in main.dart files
  // We don't need to call it again here

  // Initialize Firebase first using the FirebaseInitializer
  debugPrint('Initializing Firebase using FirebaseInitializer with timeout');

  // Create a FirebaseInitializer instance only once
  FirebaseInitializer? firebaseInitializer;

  try {
    // Check if FirebaseInitializer is already registered
    if (serviceLocator.isRegistered<FirebaseInitializer>()) {
      debugPrint(
        'FirebaseInitializer already registered, using existing instance',
      );
      firebaseInitializer = serviceLocator<FirebaseInitializer>();
    } else {
      // Create a new FirebaseInitializer instance
      firebaseInitializer = FirebaseInitializer();

      // Register it with the service locator
      serviceLocator
          .registerSingleton<FirebaseInitializer>(firebaseInitializer);
      debugPrint('Registered new FirebaseInitializer with service locator');
    }

    // Initialize Firebase with a timeout
    final firebaseResult = await firebaseInitializer.initialize(
      timeout:
          const Duration(seconds: 15), // Longer timeout for initial app startup
    );

    if (firebaseResult.isSuccess) {
      debugPrint('Firebase initialized successfully');
    } else {
      debugPrint(
        'Firebase initialization failed or timed out: ${firebaseResult.error}',
      );
      debugPrint('Error details: ${firebaseResult.errorDetails}');
      // Continue with app initialization even if Firebase fails
    }
  } catch (e) {
    debugPrint('Error during Firebase initialization: $e');
    // Continue with app initialization even if Firebase fails
  }

  // Initialize all services using the service locator
  try {
    await initializeServices();
    debugPrint('Services initialized successfully');
  } catch (e, s) {
    // If service initialization fails, log the error and continue
    debugPrint('Error initializing services: $e\n$s');

    // Try to initialize critical services individually
    try {
      // Ensure LoggerService is registered
      if (!serviceLocator.isRegistered<LoggerService>()) {
        serviceLocator.registerSingleton<LoggerService>(LoggerService());
        debugPrint('Registered LoggerService after initial failure');
      }
    } catch (innerError) {
      debugPrint('Error during fallback service registration: $innerError');
    }
  }

  // Ensure other critical services are registered
  try {
    // Ensure HiveManager is registered first and initialized synchronously
    if (!serviceLocator.isRegistered<HiveManager>()) {
      final hiveManager = HiveManager();
      serviceLocator.registerSingleton<HiveManager>(hiveManager);
      debugPrint('Registered HiveManager after initial failure');

      // Initialize Hive synchronously
      try {
        // Wait for Hive to initialize
        await hiveManager.initialize();
        debugPrint('Hive initialized successfully after initial failure');
      } catch (e) {
        debugPrint('Failed to initialize Hive after registration: $e');
        // Try one more time with a delay
        try {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          await hiveManager.initialize();
          debugPrint('Hive initialized successfully on second attempt');
        } catch (e2) {
          debugPrint('Failed to initialize Hive on second attempt: $e2');
        }
      }
    } else if (!serviceLocator<HiveManager>().isInitialized) {
      // If HiveManager is registered but not initialized, initialize it
      try {
        await serviceLocator<HiveManager>().initialize();
        debugPrint('Initialized existing HiveManager instance');
      } catch (e) {
        debugPrint('Failed to initialize existing HiveManager: $e');
      }
    }

    // Ensure StorageService is registered after HiveManager is initialized
    if (!serviceLocator.isRegistered<StorageService>()) {
      serviceLocator.registerSingleton<StorageService>(StorageService());
      debugPrint('Registered StorageService after initial failure');
    }

    // Ensure ThemeController is registered after StorageService
    if (!serviceLocator.isRegistered<ThemeController>()) {
      serviceLocator.registerSingleton<ThemeController>(ThemeController());
      debugPrint('Registered ThemeController after initial failure');
    }

    // Ensure ConnectivityService is registered
    if (!serviceLocator.isRegistered<ConnectivityService>()) {
      final connectivityService = await ConnectivityService().init();
      serviceLocator
          .registerSingleton<ConnectivityService>(connectivityService);
      debugPrint('Registered ConnectivityService after initial failure');
    }

    // Ensure ErrorService is registered
    if (!serviceLocator.isRegistered<ErrorService>()) {
      final errorService = await ErrorService().init();
      serviceLocator.registerSingleton<ErrorService>(errorService);
      debugPrint('Registered ErrorService after initial failure');
    }

    // Ensure AuthService is registered
    if (!serviceLocator.isRegistered<AuthService>()) {
      try {
        final authService = AuthService();
        serviceLocator.registerSingleton<AuthService>(authService);
        debugPrint('Registered AuthService after initial failure');
      } catch (e) {
        debugPrint('Failed to register AuthService: $e');
        // If we can't register with service locator, at least register with GetX
        try {
          if (!Get.isRegistered<AuthService>()) {
            Get.put(AuthService(), permanent: true);
            debugPrint(
              'Registered AuthService with GetX after service locator failure',
            );
          }
        } catch (getxError) {
          debugPrint('Failed to register AuthService with GetX: $getxError');
        }
      }
    }
  } catch (innerError) {
    debugPrint('Error during fallback service registration: $innerError');
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
  await _registerServicesWithGetX(logger);

  // Run the app
  logger.i('Bootstrap: Running app');
  runApp(await builder());
}

/// Register services with GetX for backward compatibility
Future<void> _registerServicesWithGetX(dynamic loggerDynamic) async {
  final logger = loggerDynamic as LoggerService;
  logger.i('Registering services with GetX for backward compatibility');

  try {
    // Register LoggerService
    if (!Get.isRegistered<LoggerService>()) {
      Get.put(serviceLocator<LoggerService>(), permanent: true);
    }

    // Register HiveManager first as StorageService depends on it
    if (!Get.isRegistered<HiveManager>()) {
      logger.i('Registering HiveManager with GetX');
      Get.put(serviceLocator<HiveManager>(), permanent: true);
    }

    // Register StorageService after HiveManager
    if (!Get.isRegistered<StorageService>()) {
      logger.i('Registering StorageService with GetX');
      Get.put(serviceLocator<StorageService>(), permanent: true);
    }

    // Register ThemeController
    if (!Get.isRegistered<ThemeController>()) {
      try {
        // Try to get ThemeController from service locator
        if (serviceLocator.isRegistered<ThemeController>()) {
          logger
              .i('Registering ThemeController with GetX from service locator');
          Get.put(serviceLocator<ThemeController>(), permanent: true);
        } else {
          // If not registered in service locator, create a new instance
          logger.i(
            'ThemeController not found in service locator, creating new instance',
          );
          final themeController = ThemeController();
          Get.put(themeController, permanent: true);

          // Also register with service locator for future use
          try {
            serviceLocator.registerSingleton<ThemeController>(themeController);
            logger.i('Registered ThemeController with service locator');
          } catch (e) {
            logger.w(
              'Failed to register ThemeController with service locator',
              e,
            );
            // Continue even if registration fails
          }
        }
      } catch (e) {
        logger.w(
          'Error registering ThemeController, creating new instance',
          e,
        );
        Get.put(ThemeController(), permanent: true);
      }
    }

    // Register ConnectivityService
    if (!Get.isRegistered<ConnectivityService>()) {
      try {
        if (serviceLocator.isRegistered<ConnectivityService>()) {
          // Use the existing instance from service locator
          logger.i(
            'Registering ConnectivityService with GetX from service locator',
          );
          Get.put(serviceLocator<ConnectivityService>(), permanent: true);
        } else {
          // Create a new instance if not in service locator
          logger.i(
            'ConnectivityService not found in service locator, creating new instance',
          );
          final connectivityService = await ConnectivityService().init();
          Get.put(connectivityService, permanent: true);

          // Also register with service locator
          try {
            serviceLocator
                .registerSingleton<ConnectivityService>(connectivityService);
            logger.i('Registered ConnectivityService with service locator');
          } catch (e) {
            logger.w(
              'Failed to register ConnectivityService with service locator',
              e,
            );
          }
        }
      } catch (e) {
        logger.w(
          'Error registering ConnectivityService, creating new instance',
          e,
        );
        final connectivityService = await ConnectivityService().init();
        Get.put(connectivityService, permanent: true);
      }
    }

    // Register ErrorService
    if (!Get.isRegistered<ErrorService>()) {
      try {
        if (serviceLocator.isRegistered<ErrorService>()) {
          // Use the existing instance from service locator
          logger.i('Registering ErrorService with GetX from service locator');
          Get.put(serviceLocator<ErrorService>(), permanent: true);
        } else {
          // Create a new instance if not in service locator
          logger.i(
            'ErrorService not found in service locator, creating new instance',
          );
          final errorService = await ErrorService().init();
          Get.put(errorService, permanent: true);

          // Also register with service locator
          try {
            serviceLocator.registerSingleton<ErrorService>(errorService);
            logger.i('Registered ErrorService with service locator');
          } catch (e) {
            logger.w('Failed to register ErrorService with service locator', e);
          }
        }
      } catch (e) {
        logger.w('Error registering ErrorService, creating new instance', e);
        final errorService = await ErrorService().init();
        Get.put(errorService, permanent: true);
      }
    }

    // Register AuthService
    if (!Get.isRegistered<AuthService>()) {
      try {
        if (serviceLocator.isRegistered<AuthService>()) {
          // Use the existing instance from service locator
          logger.i('Registering AuthService with GetX from service locator');
          Get.put(serviceLocator<AuthService>(), permanent: true);
        } else {
          // Create a new instance if not in service locator
          logger.i(
            'AuthService not found in service locator, creating new instance',
          );
          final authService = AuthService();
          Get.put(authService, permanent: true);

          // Also register with service locator
          try {
            serviceLocator.registerSingleton<AuthService>(authService);
            logger.i('Registered AuthService with service locator');
          } catch (e) {
            logger.w('Failed to register AuthService with service locator', e);
          }
        }
      } catch (e) {
        logger.w('Error registering AuthService, creating new instance', e);
        final authService = AuthService();
        Get.put(authService, permanent: true);
      }
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
