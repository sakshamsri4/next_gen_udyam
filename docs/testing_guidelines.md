# Testing Guidelines

This document outlines the testing approach for this project, which focuses on rapid development with minimal testing.

## Core Principles

1. **Development Speed First**: Prioritize rapid feature development over comprehensive testing
   
2. **Minimal Testing**: Focus on testing only critical functionality and user flows

3. **Manual Testing**: Rely on thorough manual testing across different devices and platforms

4. **Clean Code**: Write maintainable, readable code that reduces the need for extensive testing

5. **Targeted Coverage**: Aim for 5% test coverage, focusing on core business logic

## Testing Workflow

### 1. Identify Critical Paths

1. Determine which functionality is most critical to the application
2. Focus testing efforts on these critical paths
3. Prioritize user-facing features and core business logic

### 2. Implement Features First

1. Build features quickly without writing tests first
2. Focus on functionality and user experience
3. Ensure the code is clean and maintainable

### 3. Manual Testing

1. Test features thoroughly on different devices and screen sizes
2. Verify responsive behavior works correctly
3. Test on different platforms (Android, iOS, web)

## Testing Levels

### Unit Tests

- Test only critical business logic
- Focus on core functionality that affects multiple features
- Keep tests simple and focused
- Example:

```dart
void main() {
  group('AuthController', () {
    test('should validate email correctly', () {
      final controller = AuthController();
      expect(controller.isValidEmail('test@example.com'), isTrue);
      expect(controller.isValidEmail('invalid-email'), isFalse);
    });
  });
}
```

### Widget Tests

- Test only key UI components that are used throughout the app
- Focus on critical user interactions
- Example:

```dart
void main() {
  testWidgets('CustomNeoPopButton should respond to tap', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: CustomNeoPopButton(
          onTap: () => tapped = true,
          color: Colors.blue,
          child: const Text('Button'),
        ),
      ),
    );
    await tester.tap(find.text('Button'));
    await tester.pump();
    expect(tapped, isTrue);
  });
}
```

### Manual Testing Checklist

For each feature, manually test:

- Functionality on Android devices (different sizes)
- Functionality on iOS devices (different sizes)
- Functionality on web browsers (Chrome, Safari, Firefox)
- Responsive layout in portrait and landscape orientations
- Dark and light theme compatibility
- Performance and animations


## Testing Best Practices

### Efficient Testing

1. Focus on testing only what's necessary
2. Use descriptive test names that explain the expected behavior
3. Keep tests simple and maintainable
4. Test only critical user flows and business logic

### Mocking

1. Use `mocktail` for creating mocks when needed
2. Mock external dependencies like Firebase
3. Only mock what's absolutely necessary
4. Example:

```dart
class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService authService;
  late AuthController controller;

  setUp(() {
    authService = MockAuthService();
    controller = AuthController(authService);
  });

  test('login should return success for valid credentials', () {
    when(() => authService.login(any(), any()))
        .thenAnswer((_) async => true);

    expect(
      controller.login('user@example.com', 'password'),
      completion(isTrue),
    );
  });
}
```

### Responsive Testing

1. Use device preview for testing different screen sizes
2. Test critical UI components in different configurations
3. Verify adaptive layouts work correctly
4. Example:

```dart
testWidgets('JobCard adapts to different screen widths', (tester) async {
  // Test mobile layout
  tester.binding.window.devicePixelRatioTestValue = 2.0;
  tester.binding.window.physicalSizeTestValue = const Size(400, 800);
  
  await tester.pumpWidget(const MaterialApp(home: JobCard()));
  expect(find.byType(Column), findsOneWidget);
  
  // Test tablet/desktop layout
  tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
  await tester.pumpWidget(const MaterialApp(home: JobCard()));
  expect(find.byType(Row), findsOneWidget);
});
```

## Coverage Goals

1. Aim for a minimum of 5% test coverage overall
2. Focus on testing:
   - Core authentication flows
   - Data models and serialization
   - Critical business logic
   - Key UI components used throughout the app
3. Run coverage reports when needed:
   ```bash
   flutter test --coverage
   genhtml coverage/lcov.info -o coverage/html
   ```

## Manual Testing Workflow

1. Create a testing checklist for each feature
2. Test on multiple physical devices when possible
3. Use browser dev tools to test responsive layouts for web
4. Document any issues found during manual testing
5. Verify fixes with regression testing

## Continuous Integration

1. Run minimal tests on every pull request
2. Enforce basic code quality checks
3. Verify the app builds successfully for all platforms
4. Run spell check and formatting checks
