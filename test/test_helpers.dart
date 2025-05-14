import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class MockFirebaseApp {
  static Future<void> setupFirebaseAppMock() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  }
}

class GetMaterialAppTestWrapper extends StatelessWidget {
  const GetMaterialAppTestWrapper({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: child,
    );
  }
}

/// Setup for widget tests
Future<void> setupWidgetTest(WidgetTester tester, Widget widget) async {
  await MockFirebaseApp.setupFirebaseAppMock();
  await tester.pumpWidget(GetMaterialAppTestWrapper(child: widget));
}

/// Setup for controller tests
Future<void> setupControllerTest() async {
  await MockFirebaseApp.setupFirebaseAppMock();
  Get.testMode = true;
}

/// Cleanup after tests
void cleanupTest() {
  Get.reset();
}
