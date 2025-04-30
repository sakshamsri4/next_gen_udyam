# Test-Driven Development (TDD) Guidelines

This document outlines the Test-Driven Development approach for this project.

## Core Principles

1. **Red-Green-Refactor**: Follow the TDD cycle:
   - **Red**: Write a failing test
   - **Green**: Write the minimum code to make the test pass
   - **Refactor**: Improve the code while keeping tests passing

2. **Test First**: Always write tests before implementing features.

3. **Small Steps**: Make incremental changes and test each step.

4. **Clean Tests**: Tests should be readable, maintainable, and reliable.

5. **Complete Coverage**: Aim for comprehensive test coverage of all code.

## TDD Workflow

### 1. Write a Failing Test

1. Identify the smallest piece of functionality to implement.
2. Write a test that defines the expected behavior.
3. Run the test to verify it fails (Red).
4. Ensure the test fails for the expected reason.

### 2. Make the Test Pass

1. Write the minimum code necessary to make the test pass.
2. Focus on functionality, not optimization or elegance.
3. Run the test to verify it passes (Green).
4. Resist the urge to add functionality beyond what's needed for the test.

### 3. Refactor

1. Improve the code while keeping tests passing.
2. Look for duplication, unclear names, or complex logic.
3. Run tests after each refactoring step.
4. Consider both production code and test code for refactoring.

### 4. Repeat

1. Move on to the next small piece of functionality.
2. Continue the Red-Green-Refactor cycle.

## Testing Levels

### Unit Tests

- Test individual classes, methods, or functions in isolation.
- Mock dependencies to focus on the unit being tested.
- Use `test` package for non-widget tests.
- Example:

```dart
void main() {
  group('CounterCubit', () {
    test('initial state is 0', () {
      expect(CounterCubit().state, equals(0));
    });

    test('increments the state', () {
      final cubit = CounterCubit();
      cubit.increment();
      expect(cubit.state, equals(1));
    });
  });
}
```

### Widget Tests

- Test individual widgets or small widget trees.
- Focus on widget behavior and interactions.
- Use `flutter_test` package and `testWidgets` function.
- Example:

```dart
void main() {
  testWidgets('Counter increments when button is pressed', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });
}
```

### Integration Tests

- Test interactions between multiple components.
- Focus on feature workflows and user journeys.
- Use `integration_test` package for full app testing.
- Example:

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete user login flow', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextField).first, 'username');
    await tester.enterText(find.byType(TextField).last, 'password');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, username!'), findsOneWidget);
  });
}
```



## Testing Best Practices

### Test Structure

1. Use `group` to organize related tests.
2. Use descriptive test names that explain the expected behavior.
3. Follow the Arrange-Act-Assert pattern:
   - **Arrange**: Set up the test environment
   - **Act**: Perform the action being tested
   - **Assert**: Verify the expected outcome

### Mocking

1. Use `mocktail` for creating mocks.
2. Mock external dependencies to isolate the unit being tested.
3. Only mock what's necessary for the test.
4. Example:

```dart
class MockRepository extends Mock implements Repository {}

void main() {
  late MockRepository repository;
  late MyBloc bloc;

  setUp(() {
    repository = MockRepository();
    bloc = MyBloc(repository);
  });

  test('emits [loading, success] when data is fetched successfully', () {
    when(() => repository.getData()).thenAnswer((_) async => 'data');

    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<LoadingState>(),
        isA<SuccessState>(),
      ]),
    );

    bloc.fetchData();
  });
}
```

### Test Helpers

1. Create helper functions for common test operations.
2. Use `setUp` and `tearDown` for test initialization and cleanup.
3. Share fixtures and test data across tests.
4. Example:

```dart
Widget buildTestWidget({required Widget child}) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('MyWidget displays correct text', (tester) async {
    await tester.pumpWidget(buildTestWidget(child: const MyWidget()));
    expect(find.text('Expected Text'), findsOneWidget);
  });
}
```

## Testing NeoPop Widgets

1. Test both appearance and behavior of NeoPop widgets.
2. Verify correct styling, colors, and dimensions.
3. Test interactions like taps, drags, and state changes.
4. Example:

```dart
testWidgets('NeoPop button changes state when pressed', (tester) async {
  bool wasPressed = false;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: NeoPopButton(
          onTapUp: () => wasPressed = true,
          child: const Text('Press Me'),
        ),
      ),
    ),
  );

  await tester.tap(find.text('Press Me'));
  await tester.pump();

  expect(wasPressed, isTrue);
});
```

## Coverage Goals

1. Aim for a minimum of 5% test coverage overall.
2. Prioritize coverage of business logic and complex components.
3. Run coverage reports regularly:
   ```bash
   flutter test --coverage
   genhtml coverage/lcov.info -o coverage/html
   ```
4. Gradually increase coverage targets as the project matures.

## Handling Flaky Tests

1. Identify and fix flaky tests immediately.
2. Common causes of flaky tests:
   - Asynchronous operations not properly awaited
   - Timing issues with animations or transitions
   - Dependencies on external services
   - Order-dependent tests
3. Use `pumpAndSettle()` for waiting for animations to complete.
4. Add appropriate timeouts for async operations.
5. Isolate tests from external dependencies.

## Continuous Integration

1. Run tests automatically on every pull request.
2. Enforce minimum coverage requirements in CI.
3. Block merges if tests fail.
4. Generate and publish coverage reports.
