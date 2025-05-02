// ignore_for_file: cascade_invocations

import 'dart:async';
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/core/services/connectivity_service.dart';
import 'package:next_gen/core/services/error_service.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/storage_service.dart';
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

  // Initialize Logger Service first
  // Use put instead of lazyPut if it needs to be available immediately
  final logger = Get.put(LoggerService(), permanent: true);
  logger.i('Logger Service Initialized');

  FlutterError.onError = (details) {
    // Use LoggerService for Flutter errors
    logger.e('FlutterError caught', details.exception, details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here

  try {
    // Initialize Firebase
    logger.i('Initializing Firebase...');
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      logger.i('Firebase Initialized Successfully');
    } catch (e, s) {
      // Firebase might already be initialized, which is fine
      logger.w(
        'Firebase initialization issue (might be already initialized)',
        e,
        s,
      );
    }

    // Initialize Hive using StorageService
    logger.i('Initializing Hive...');
    try {
      await StorageService.init();
      logger.i('StorageService Initialized Successfully');
    } catch (e, s) {
      logger.e('StorageService initialization failed', e, s);
      // This is critical, so rethrow
      rethrow;
    }

    // Initialize ThemeController
    logger.i('Initializing ThemeController...');
    try {
      Get.put(ThemeController(), permanent: true);
      logger.i('ThemeController Initialized Successfully');
    } catch (e, s) {
      logger.e('ThemeController initialization failed', e, s);
      // This is important but not critical, continue
    }

    // Initialize ConnectivityService
    logger.i('Initializing ConnectivityService...');
    try {
      final connectivityService = Get.put(
        await ConnectivityService().init(),
        permanent: true,
      );
      logger.i('ConnectivityService Initialized Successfully');

      // Check initial connectivity
      final status = connectivityService.status;
      logger.i('Initial connectivity status: $status');
    } catch (e, s) {
      logger.e('ConnectivityService initialization failed', e, s);
      // This is important but not critical, continue
    }

    // Initialize ErrorService
    logger.i('Initializing ErrorService...');
    try {
      Get.put(
        await ErrorService().init(),
        permanent: true,
      );
      logger.i('ErrorService Initialized Successfully');
    } catch (e, s) {
      logger.e('ErrorService initialization failed', e, s);
      // This is important but not critical, continue
    }

    // Initialize AuthService
    logger.i('Initializing AuthService...');
    try {
      final authService = Get.put(AuthService(), permanent: true);
      logger.i('AuthService Initialized Successfully');

      // Try to restore user session
      logger.i('Checking for persisted login...');
      final user = await authService.restoreUserSession();
      if (user != null) {
        logger.i('Found persisted login for user: ${user.uid}');
      } else {
        logger.d('No persisted login found or session expired');
      }
    } catch (e, s) {
      logger.e('AuthService initialization failed', e, s);
      // This is important but not critical, continue
    }
  } catch (e, s) {
    logger.e('Initialization Error during bootstrap', e, s);
    // Log the error but continue - the App widget will handle
    // missing dependencies
  }

  runApp(await builder());
}
