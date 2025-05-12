import 'package:get_it/get_it.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
import 'package:next_gen/app/modules/auth/services/signup_session_service.dart';
import 'package:next_gen/core/firebase/firebase_initializer.dart';
// Analytics service commented out for now, will be implemented later
// import 'package:next_gen/core/services/analytics_service.dart';
import 'package:next_gen/core/services/connectivity_service.dart';
import 'package:next_gen/core/services/error_service.dart';
import 'package:next_gen/core/services/logger_service.dart';
import 'package:next_gen/core/storage/hive_manager.dart';
import 'package:next_gen/core/storage/storage_service.dart';
import 'package:next_gen/core/theme/theme_controller.dart';

/// Global service locator instance
final serviceLocator = GetIt.instance;

/// Initialize all services
Future<void> initializeServices() async {
  // Register logger service first (needed by other services)
  serviceLocator.registerSingleton<LoggerService>(LoggerService());
  final logger = serviceLocator<LoggerService>()
    ..i('Service Locator: Logger service registered')

    // Register Firebase initializer
    ..i('Service Locator: Registering Firebase initializer...');

  serviceLocator.registerSingleton<FirebaseInitializer>(FirebaseInitializer());

  logger
    ..i('Service Locator: Firebase initializer registered')

    // Register storage services
    ..i('Service Locator: Registering storage services...');

  // Register HiveManager first and initialize it
  serviceLocator.registerSingleton<HiveManager>(HiveManager());

  // Initialize Hive before registering StorageService
  logger.i('Service Locator: Initializing Hive...');
  await serviceLocator<HiveManager>().initialize();

  // Register StorageService after Hive is initialized
  logger.i('Service Locator: Registering StorageService...');
  serviceLocator.registerSingleton<StorageService>(StorageService());

  logger
    ..i('Service Locator: Hive initialized and StorageService registered')

    // Register connectivity service with retry mechanism
    ..i('Service Locator: Registering connectivity service...');

  // Try to initialize ConnectivityService with retries
  ConnectivityService? connectivityService;
  for (var attempt = 1; attempt <= 3; attempt++) {
    try {
      logger.d('Initializing ConnectivityService (attempt $attempt)');
      connectivityService = await ConnectivityService().init();
      logger.d(
        'ConnectivityService initialized successfully on attempt $attempt',
      );
      break;
    } catch (e) {
      logger.e('Error initializing ConnectivityService on attempt $attempt', e);
      if (attempt < 3) {
        // Wait before retrying
        await Future<void>.delayed(Duration(milliseconds: 300 * attempt));
      }
    }
  }

  // If all attempts failed, create an instance without initialization
  if (connectivityService == null) {
    logger.w(
      'All ConnectivityService initialization attempts failed, creating uninitialized instance',
    );
    connectivityService = ConnectivityService();
  }

  serviceLocator.registerSingleton<ConnectivityService>(connectivityService);
  logger
    ..i('Service Locator: Connectivity service registered')

    // Register error service with retry mechanism
    ..i('Service Locator: Registering error service...');

  // Try to initialize ErrorService with retries
  ErrorService? errorService;
  for (var attempt = 1; attempt <= 3; attempt++) {
    try {
      logger.d('Initializing ErrorService (attempt $attempt)');
      errorService = await ErrorService().init();
      logger.d(
        'ErrorService initialized successfully on attempt $attempt',
      );
      break;
    } catch (e) {
      logger.e('Error initializing ErrorService on attempt $attempt', e);
      if (attempt < 3) {
        // Wait before retrying
        await Future<void>.delayed(Duration(milliseconds: 300 * attempt));
      }
    }
  }

  // If all attempts failed, create an instance without initialization
  if (errorService == null) {
    logger.w(
      'All ErrorService initialization attempts failed, creating uninitialized instance',
    );
    errorService = ErrorService();
  }

  serviceLocator.registerSingleton<ErrorService>(errorService);
  logger
    ..i('Service Locator: Error service registered')

    // Register theme controller
    ..i('Service Locator: Registering theme controller...');
  serviceLocator.registerSingleton<ThemeController>(ThemeController());
  logger
    ..i('Service Locator: Theme controller registered')

    // Register auth service
    ..i('Service Locator: Registering auth service...');
  serviceLocator.registerSingleton<AuthService>(AuthService());
  logger
    ..i('Service Locator: Auth service registered')

    // Register signup session service
    ..i('Service Locator: Registering signup session service...');
  serviceLocator
      .registerSingleton<SignupSessionService>(SignupSessionService());
  logger
    ..i('Service Locator: Signup session service registered')

    // Analytics service commented out for now, will be implemented later
    /*
    ..i('Service Locator: Registering analytics service...');
    final analyticsService = await AnalyticsService().init();
    serviceLocator.registerSingleton<AnalyticsService>(analyticsService);
    logger.i('Service Locator: Analytics service registered');
    */
    ..i('Service Locator: All services registered successfully');
}
