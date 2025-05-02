import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:next_gen/app/modules/auth/views/login_view.dart';
import 'package:next_gen/app/modules/auth/views/signup_view.dart';

/// Utility class for auth module UI testing
class AuthViewTestHelper {
  /// Sets up a standard test widget for Login page testing
  ///
  /// Requires mockAuthController and mockGet to be passed
  static Future<void> pumpLoginView(
    WidgetTester tester, {
    required dynamic mockAuthController,
    required dynamic mockGet,
  }) async {
    // Provide mock dependencies
    Get
      ..put<dynamic>(mockAuthController)
      ..replace(mockGet);

    await tester.pumpWidget(
      GetMaterialApp(
        home: const LoginView(),
        getPages: [
          GetPage(name: '/signup', page: () => const SignupView()),
        ],
      ),
    );
  }

  /// Sets up a standard test widget for Signup page testing
  ///
  /// Requires mockAuthController and mockGet to be passed
  static Future<void> pumpSignupView(
    WidgetTester tester, {
    required dynamic mockAuthController,
    required dynamic mockGet,
  }) async {
    // Provide mock dependencies
    Get
      ..put<dynamic>(mockAuthController)
      ..replace(mockGet);

    await tester.pumpWidget(
      GetMaterialApp(
        home: const SignupView(),
        getPages: [
          GetPage(name: '/login', page: () => const LoginView()),
        ],
      ),
    );
  }

  /// Finds and tests essential auth form elements
  ///
  /// Returns a map of finders for each form element for further testing
  static Map<String, Finder> verifyAuthFormElements(
    WidgetTester tester, {
    required List<String> expectedTextFields,
    required List<String> expectedButtons,
  }) {
    final foundFinders = <String, Finder>{};

    // Find text fields
    for (final field in expectedTextFields) {
      final finder = find.widgetWithText(TextField, field);
      expect(finder, findsOneWidget, reason: '$field field not found');
      foundFinders[field] = finder;
    }

    // Find buttons
    for (final button in expectedButtons) {
      final finder = find.text(button);
      expect(finder, findsOneWidget, reason: '$button button not found');
      foundFinders[button] = finder;
    }

    return foundFinders;
  }

  /// Enters text into form fields
  static Future<void> enterTextInFields(
    WidgetTester tester, {
    required Map<Finder, String> fieldsAndValues,
  }) async {
    for (final entry in fieldsAndValues.entries) {
      await tester.enterText(entry.key, entry.value);
    }
    await tester.pump();
  }
}

/// Custom auth-related matchers for test assertions
class AuthMatchers {
  /// Matches if a widget is enabled and tappable
  static Matcher isEnabledButton = isA<Widget>().having(
    (w) => w is ElevatedButton && w.onPressed != null,
    'is enabled button',
    true,
  );

  /// Matches if a widget is an AuthController with the expected properties
  static Matcher isAuthController({
    bool? isLoading,
    bool? isLoggedIn,
    String? errorMessage,
  }) {
    return isA<dynamic>()
        .having(
          (dynamic c) => isLoading == null || c.isLoading.value == isLoading,
          'isLoading',
          true,
        )
        .having(
          (dynamic c) => isLoggedIn == null || c.isLoggedIn.value == isLoggedIn,
          'isLoggedIn',
          true,
        )
        .having(
          (dynamic c) =>
              errorMessage == null || c.errorMessage.value == errorMessage,
          'errorMessage',
          true,
        );
  }
}
