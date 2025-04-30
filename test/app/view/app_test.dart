import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:next_gen/app/modules/auth/controllers/auth_controller.dart';

// Simple TestApp that doesn't depend on firebase or GetX routing
class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Next Gen Test App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Auth Module Test')),
        body: const Center(
          child: Text('Auth Module Test'),
        ),
      ),
    );
  }
}

class MockAuthController extends Mock implements AuthController {}

void main() {
  // Initialize Flutter binding for tests
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Reset GetX between tests
    Get
      ..reset()

      // Set test mode
      ..testMode = true;

    // Put a mock auth controller to prevent GetX from looking for it
    final mockAuthController = MockAuthController();
    Get.put<AuthController>(mockAuthController);
  });

  group('App', () {
    testWidgets('renders test app correctly', (tester) async {
      await tester.pumpWidget(const TestApp());

      // Check that the app renders correctly
      expect(find.text('Auth Module Test'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
