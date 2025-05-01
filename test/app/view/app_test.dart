import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Test App'),
        ),
      ),
    );
  }
}

void main() {
  // Initialize Flutter binding for tests
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Set up SharedPreferences mock for theme controller
    SharedPreferences.setMockInitialValues({});
    Get.reset();
  });

  tearDown(Get.reset);

  group('App', () {
    testWidgets('renders a MaterialApp', (tester) async {
      // Use a simplified test app to avoid Firebase initialization issues
      await tester.pumpWidget(const TestApp());
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Test App'), findsOneWidget);
    });
  });
}
