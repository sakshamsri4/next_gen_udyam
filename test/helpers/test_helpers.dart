import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

/// A utility for creating type-safe matchers for non-nullable types in Mockito
class TypeSafeMatchers {
  /// Creates a matcher for non-nullable Strings
  static String get anyString => _TypeSafeMatcher<String>() as String;

  /// Creates a matcher for non-nullable Widgets
  static Widget get anyWidget => _TypeSafeMatcher<Widget>() as Widget;
}

/// A helper class that creates type-safe matchers
class _TypeSafeMatcher<T> {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

/// A utility class for testing Firebase authentication exceptions
class FirebaseAuthExceptionTester {
  /// Tests a function with various Firebase auth exception codes
  ///
  /// [testFunction] is the function that should throw the exception
  /// [errorMessageGetter] is a function that returns the error message from your state
  /// [expectedMessages] is a map of exception codes to expected error messages
  static void testAuthExceptions({
    required void Function() testFunction,
    required String Function() errorMessageGetter,
    required Map<String, String> expectedMessages,
  }) {
    for (final entry in expectedMessages.entries) {
      final code = entry.key;
      final expectedMessage = entry.value;

      // Arrange & Act
      testFunction();

      // Assert
      expect(
        errorMessageGetter(),
        expectedMessage,
        reason: 'Failed for code: $code',
      );
    }
  }

  /// Common Firebase auth exception codes and their expected messages
  static Map<String, String> get commonAuthExceptions => {
        'user-not-found': 'No user found with this email',
        'wrong-password': 'Wrong password',
        'email-already-in-use': 'Email is already in use',
        'weak-password': 'Password is too weak',
        'invalid-email': 'Invalid email format',
        'operation-not-allowed': 'This operation is not allowed',
        'account-exists-with-different-credential':
            'An account already exists with a different sign-in method',
        'invalid-credential': 'The credential is invalid',
        'user-disabled': 'This user account has been disabled',
      };
}

/// A utility class for testing UI components with GetX
class GetTestWidgetHelper {
  /// Builds a test widget with GetMaterialApp for testing
  ///
  /// [child] is the widget to test
  /// [getPages] is an optional list of GetPage objects for navigation
  /// [initialRoute] is the initial route for the GetMaterialApp
  static Widget buildGetTestWidget({
    required Widget child,
    List<GetPage<dynamic>>? getPages,
    String? initialRoute,
  }) {
    return GetMaterialApp(
      getPages: getPages ?? [],
      initialRoute: initialRoute,
      home: Scaffold(
        body: child,
      ),
    );
  }

  /// Sets up GetX test mode and ensures it's properly reset
  static void setupGetTest() {
    Get.testMode = true;
  }

  /// Resets GetX after a test
  static void tearDownGetTest() {
    Get.reset();
  }
}

/// A mock implementation of SnackbarController for testing
class MockSnackbarController implements SnackbarController {
  @override
  Future<void> close({bool withAnimations = true}) async {}

  @override
  void dismiss({bool withAnimations = true}) {}

  @override
  bool get isDismissible => true;

  @override
  bool get isShowing => false;

  @override
  Future<void> show() async {}

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MockSnackbarController';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

/// A mixin to add table-driven test functionality to test classes
mixin TableDrivenTests {
  /// Run a table-driven test with multiple inputs and expected outputs
  ///
  /// [testName] is the name of the test
  /// [testCases] is a list of test cases with inputs and expected outputs
  /// [testFunction] is the function that runs each test case
  void testWithTable<I, E>({
    required String testName,
    required List<({String description, I input, E expected})> testCases,
    required void Function(String description, I input, E expected)
        testFunction,
  }) {
    group(testName, () {
      for (final testCase in testCases) {
        test(testCase.description, () {
          testFunction(
            testCase.description,
            testCase.input,
            testCase.expected,
          );
        });
      }
    });
  }
}
