// ignore_for_file: cascade_invocations

import 'dart:async';
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
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
    logger.i('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    logger.i('Firebase Initialized Successfully');
    logger.i('Initializing Hive...');

    // Initialize Hive using StorageService
    logger.d('Initializing StorageService...');
    await StorageService.init();
    logger.i('StorageService Initialized Successfully');

    // Initialize ThemeController
    logger.i('Initializing ThemeController...');
    Get.put(ThemeController(), permanent: true);
    logger.i('ThemeController Initialized Successfully');

    // Initialize AuthService
    logger.i('Initializing AuthService...');
    Get.put(AuthService(), permanent: true);
    logger.i('AuthService Initialized Successfully');
  } catch (e, s) {
    logger.e('Initialization Error during bootstrap', e, s);
    // Optionally rethrow or handle critical failure
  }

  runApp(await builder());
}
