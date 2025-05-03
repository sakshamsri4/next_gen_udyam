import 'package:get_it/get_it.dart';
import 'package:next_gen/app/modules/auth/services/auth_service.dart';
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
  final logger = serviceLocator<LoggerService>();
  logger.i('Service Locator: Logger service registered');

  // Register storage services
  logger.i('Service Locator: Registering storage services...');
  serviceLocator.registerSingleton<HiveManager>(HiveManager());
  serviceLocator.registerSingleton<StorageService>(StorageService());

  // Initialize Hive
  logger.i('Service Locator: Initializing Hive...');
  await serviceLocator<HiveManager>().initialize();
  logger.i('Service Locator: Hive initialized');

  // Register connectivity service
  logger.i('Service Locator: Registering connectivity service...');
  final connectivityService = await ConnectivityService().init();
  serviceLocator.registerSingleton<ConnectivityService>(connectivityService);
  logger.i('Service Locator: Connectivity service registered');

  // Register error service
  logger.i('Service Locator: Registering error service...');
  final errorService = await ErrorService().init();
  serviceLocator.registerSingleton<ErrorService>(errorService);
  logger.i('Service Locator: Error service registered');

  // Register theme controller
  logger.i('Service Locator: Registering theme controller...');
  serviceLocator.registerSingleton<ThemeController>(ThemeController());
  logger.i('Service Locator: Theme controller registered');

  // Register auth service
  logger.i('Service Locator: Registering auth service...');
  serviceLocator.registerSingleton<AuthService>(AuthService());
  logger.i('Service Locator: Auth service registered');

  // Analytics service commented out for now, will be implemented later
  /*
  logger.i('Service Locator: Registering analytics service...');
  final analyticsService = await AnalyticsService().init();
  serviceLocator.registerSingleton<AnalyticsService>(analyticsService);
  logger.i('Service Locator: Analytics service registered');
  */

  logger.i('Service Locator: All services registered successfully');
}
