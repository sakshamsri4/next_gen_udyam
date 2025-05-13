// ignore_for_file: cascade_invocations

import 'dart:async';
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/modules/auth/services/signup_session_service.dart';
import 'package:next_gen/app/shared/controllers/navigation_controller.dart';
import 'package:next_gen/app/shared/widgets/role_based_navigation_factory.dart';
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

  // Use a retry mechanism for Firebase initialization
  for (var attempt = 1; attempt <= 3; attempt++) {
    try {
      debugPrint('Firebase initialization attempt $attempt');

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
        timeout: Duration(
          seconds: 15 + (5 * attempt),
        ), // Increase timeout with each attempt
      );

      if (firebaseResult.isSuccess) {
        debugPrint('Firebase initialized successfully on attempt $attempt');
        break; // Exit the retry loop on success
      } else {
        debugPrint(
          'Firebase initialization failed on attempt $attempt: ${firebaseResult.error}',
        );
        debugPrint('Error details: ${firebaseResult.errorDetails}');

        if (attempt < 3) {
          // Wait before retrying
          final delay = Duration(milliseconds: 500 * attempt);
          debugPrint('Waiting ${delay.inMilliseconds}ms before next attempt');
          await Future<void>.delayed(delay);
        } else {
          debugPrint('All Firebase initialization attempts failed');
          // Continue with app initialization even if Firebase fails
        }
      }
    } catch (e) {
      debugPrint('Error during Firebase initialization attempt $attempt: $e');

      if (attempt < 3) {
        // Wait before retrying
        final delay = Duration(milliseconds: 500 * attempt);
        debugPrint('Waiting ${delay.inMilliseconds}ms before next attempt');
        await Future<void>.delayed(delay);
      } else {
        debugPrint('All Firebase initialization attempts failed');
        // Continue with app initialization even if Firebase fails
      }
    }
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

      // Initialize Hive synchronously with retry mechanism
      for (var attempt = 1; attempt <= 3; attempt++) {
        try {
          debugPrint('Attempting to initialize Hive (attempt $attempt)');
          // Wait for Hive to initialize
          await hiveManager.initialize();
          debugPrint('Hive initialized successfully on attempt $attempt');
          break; // Exit the loop if successful
        } catch (e) {
          debugPrint('Failed to initialize Hive on attempt $attempt: $e');
          if (attempt < 3) {
            // Increase delay with each attempt
            final delay = Duration(milliseconds: 500 * attempt);
            debugPrint('Waiting ${delay.inMilliseconds}ms before next attempt');
            await Future<void>.delayed(delay);
          } else {
            debugPrint('All Hive initialization attempts failed');
          }
        }
      }
    } else if (!serviceLocator<HiveManager>().isInitialized) {
      // If HiveManager is registered but not initialized, initialize it with retry
      debugPrint(
        'HiveManager is registered but not initialized, initializing now',
      );
      for (var attempt = 1; attempt <= 3; attempt++) {
        try {
          debugPrint(
            'Attempting to initialize existing HiveManager (attempt $attempt)',
          );
          await serviceLocator<HiveManager>().initialize();
          debugPrint(
            'Initialized existing HiveManager instance on attempt $attempt',
          );
          break; // Exit the loop if successful
        } catch (e) {
          debugPrint(
            'Failed to initialize existing HiveManager on attempt $attempt: $e',
          );
          if (attempt < 3) {
            // Increase delay with each attempt
            final delay = Duration(milliseconds: 500 * attempt);
            debugPrint('Waiting ${delay.inMilliseconds}ms before next attempt');
            await Future<void>.delayed(delay);
          } else {
            debugPrint('All HiveManager initialization attempts failed');
          }
        }
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
/// This simplified version ensures we only register each service once
/// and always use the instance from the service locator if available
Future<void> _registerServicesWithGetX(LoggerService logger) async {
  logger.i('Registering services with GetX for backward compatibility');

  try {
    // Define a helper function to register a service
    void registerService<T>(T instance, String serviceName) {
      if (!Get.isRegistered<T>()) {
        Get.put<T>(instance, permanent: true);
        logger.d('Registered $serviceName with GetX');
      } else {
        logger.d('$serviceName already registered with GetX');
      }
    }

    // Register all services from the service locator
    // This ensures we're using the same instances in both GetIt and GetX

    // Core services
    registerService<LoggerService>(
      serviceLocator<LoggerService>(),
      'LoggerService',
    );

    registerService<HiveManager>(
      serviceLocator<HiveManager>(),
      'HiveManager',
    );

    registerService<StorageService>(
      serviceLocator<StorageService>(),
      'StorageService',
    );

    registerService<ThemeController>(
      serviceLocator<ThemeController>(),
      'ThemeController',
    );

    // Network services
    if (serviceLocator.isRegistered<ConnectivityService>()) {
      registerService<ConnectivityService>(
        serviceLocator<ConnectivityService>(),
        'ConnectivityService',
      );
    }

    // Error handling
    if (serviceLocator.isRegistered<ErrorService>()) {
      registerService<ErrorService>(
        serviceLocator<ErrorService>(),
        'ErrorService',
      );
    }

    // Auth services
    if (serviceLocator.isRegistered<AuthService>()) {
      registerService<AuthService>(
        serviceLocator<AuthService>(),
        'AuthService',
      );
    }

    // Signup session service
    if (serviceLocator.isRegistered<SignupSessionService>()) {
      registerService<SignupSessionService>(
        serviceLocator<SignupSessionService>(),
        'SignupSessionService',
      );
    }

    // Firebase services
    if (serviceLocator.isRegistered<FirebaseInitializer>()) {
      registerService<FirebaseInitializer>(
        serviceLocator<FirebaseInitializer>(),
        'FirebaseInitializer',
      );
    }

    // Navigation controller
    try {
      // Check if NavigationController is already registered with GetX
      if (!Get.isRegistered<NavigationController>()) {
        // Create a new instance and register it
        final navigationController = NavigationController();
        Get.put<NavigationController>(navigationController, permanent: true);
        logger.i('Registered NavigationController with GetX');

        // Initialize RoleBasedNavigationFactory
        RoleBasedNavigationFactory.init();
        logger.i('Initialized RoleBasedNavigationFactory');
      } else {
        logger.d('NavigationController already registered with GetX');

        // Initialize RoleBasedNavigationFactory if not already done
        RoleBasedNavigationFactory.init();
        logger.d('Initialized RoleBasedNavigationFactory');
      }
    } catch (e) {
      logger.e('Error registering NavigationController', e);
    }

    // Analytics service commented out for now, will be implemented later
    /*
    if (serviceLocator.isRegistered<AnalyticsService>()) {
      registerService<AnalyticsService>(
        serviceLocator<AnalyticsService>(),
        'AnalyticsService'
      );
    }
    */

    logger.i('All services registered with GetX successfully');
  } catch (e, s) {
    logger.e('Error registering services with GetX', e, s);
  }
}
