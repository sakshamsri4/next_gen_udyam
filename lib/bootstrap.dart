import 'dart:async';
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive Flutter
import 'package:next_gen/app/modules/auth/models/user_model.dart'; // Import UserModel
import 'package:next_gen/app/modules/auth/services/auth_service.dart'; // Import AuthService
import 'package:next_gen/core/services/logger_service.dart'; // Import LoggerService
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
      final logger = Get.find<LoggerService>();
      logger.e('Bloc onError(${bloc.runtimeType})', error, stackTrace);
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
  Get.put(LoggerService(), permanent: true);
  final logger = Get.find<LoggerService>();
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

    // Initialize Hive
    logger.i('Initializing Hive...');
    await Hive.initFlutter(); // Initialize Hive for Flutter

    // Register Adapters for custom objects
    logger.d('Registering Hive adapters...');
    Hive.registerAdapter(UserModelAdapter());

    // Open boxes needed globally at startup
    logger.d('Opening Hive boxes...');
    await Hive.openBox<UserModel>('user_box');

    logger.i('Hive Initialized Successfully');

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
