import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/error/bindings/error_binding.dart';
import 'package:next_gen/app/modules/error/controllers/error_controller.dart';
import 'package:next_gen/app/modules/error/views/error_view.dart';
import 'package:next_gen/app/modules/error/widgets/error_widget.dart';
import 'package:next_gen/app/modules/error/widgets/network_status_widget.dart';
import 'package:next_gen/core/services/connectivity_service.dart';
import 'package:next_gen/core/services/error_service.dart';
import 'package:next_gen/core/services/logger_service.dart';

void main() {
  setUp(() {
    // Initialize GetX test environment
    Get.testMode = true;

    // Register required services
    Get.put(LoggerService(), permanent: true);

    // Initialize binding
  });

  tearDown(Get.reset);

  group('ErrorBinding', () {
    test('registers all required dependencies', () {
      expect(Get.isRegistered<LoggerService>(), true);
      expect(Get.isRegistered<ConnectivityService>(), true);
      expect(Get.isRegistered<ErrorService>(), true);
      expect(Get.isRegistered<ErrorController>(), true);
    });
  });

  group('ErrorController', () {
    test('initializes with default values', () {
      final controller = Get.find<ErrorController>();

      expect(controller.errorTitle.value, 'An error occurred');
      expect(
        controller.errorMessage.value,
        'Something went wrong. Please try again later.',
      );
      expect(controller.errorCode.value, null);
      expect(controller.canGoBack.value, true);
      expect(controller.onRetry.value, null);
    });

    test('setErrorDetails updates values correctly', () {
      final controller = Get.find<ErrorController>();
      void callback() {}

      controller.setErrorDetails(
        title: 'Test Error',
        message: 'Test Message',
        code: 'E123',
        retry: callback,
        allowBack: false,
      );

      expect(controller.errorTitle.value, 'Test Error');
      expect(controller.errorMessage.value, 'Test Message');
      expect(controller.errorCode.value, 'E123');
      expect(controller.canGoBack.value, false);
      expect(controller.onRetry.value, callback);
    });
  });

  group('ErrorView', () {
    testWidgets('renders correctly with default values', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const ErrorView(),
          initialBinding: ErrorBinding(),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(NetworkStatusWidget), findsOneWidget);
      expect(find.byType(CustomErrorWidget), findsOneWidget);
    });

    testWidgets('renders correctly with custom values', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const ErrorView(
            title: 'Custom Error',
            message: 'Custom Message',
            errorCode: 'E456',
            canGoBack: false,
            showNetworkStatus: false,
          ),
          initialBinding: ErrorBinding(),
        ),
      );

      expect(find.byType(AppBar), findsNothing);
      expect(find.byType(NetworkStatusWidget), findsNothing);
      expect(find.byType(CustomErrorWidget), findsOneWidget);

      // Verify custom values are used
      final controller = Get.find<ErrorController>();
      expect(controller.errorTitle.value, 'Custom Error');
      expect(controller.errorMessage.value, 'Custom Message');
      expect(controller.errorCode.value, 'E456');
      expect(controller.canGoBack.value, false);
    });
  });
}
