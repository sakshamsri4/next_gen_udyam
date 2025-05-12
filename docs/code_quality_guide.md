# Code Quality Guide

This document outlines common code quality issues in the Next Gen Job Portal project and provides solutions for them.

## Common Issues and Solutions

### 1. Deprecated API Usage

#### Issue: `withOpacity` is deprecated
```dart
// Bad
color: Colors.black.withOpacity(0.5)
```

#### Solution: Use `withAlpha` instead
```dart
// Good
color: Colors.black.withAlpha(128) // 0.5 * 255 = 128
```

### 2. Null Safety Issues

#### Issue: Casting nullable values to non-nullable types
```dart
// Bad
final data = doc.data() as Map<String, dynamic>;
```

#### Solution: Add null checks
```dart
// Good
final data = doc.data();
if (data == null) {
  // Handle null case
  return;
}
final typedData = data as Map<String, dynamic>;
```

### 3. Unnecessary Code

#### Issue: Unnecessary break statements in switch cases
```dart
// Bad
switch (status) {
  case 'active':
    result = Status.active;
    break; // Unnecessary when it's the last statement in the case
  case 'inactive':
    result = Status.inactive;
    break; // Unnecessary when it's the last statement in the case
}
```

#### Solution: Remove unnecessary breaks
```dart
// Good
switch (status) {
  case 'active':
    result = Status.active;
  case 'inactive':
    result = Status.inactive;
}
```

#### Issue: Unnecessary lambdas
```dart
// Bad
button.onPressed = () => doSomething();
```

#### Solution: Use tear-offs
```dart
// Good
button.onPressed = doSomething;
```

#### Issue: Unnecessary type annotations
```dart
// Bad
final List<String> items = ['a', 'b', 'c'];
```

#### Solution: Let Dart infer the type
```dart
// Good
final items = ['a', 'b', 'c'];
```

### 4. Widget Issues

#### Issue: Using undefined widgets
```dart
// Bad
NeoPopButton(
  color: Colors.blue,
  onTap: () {},
  child: Text('Button'),
)
```

#### Solution: Use the correct widget name
```dart
// Good
CustomNeoPopButton(
  color: Colors.blue,
  onTap: () {},
  child: Text('Button'),
)
```

### 5. Import Issues

#### Issue: Unused imports
```dart
// Bad
import 'package:flutter/material.dart';
import 'package:unused_package.dart'; // Unused
```

#### Solution: Remove unused imports
```dart
// Good
import 'package:flutter/material.dart';
```

#### Issue: Incorrect import paths
```dart
// Bad
import 'package:next_gen/ui/theme/app_theme.dart'; // Path doesn't exist
```

#### Solution: Use the correct path
```dart
// Good
import 'package:next_gen/core/theme/app_theme.dart'; // Correct path
```

### 6. Code Style Issues

#### Issue: Inconsistent directive ordering
```dart
// Bad
import 'package:flutter/material.dart';
import 'dart:async';
```

#### Solution: Sort imports alphabetically
```dart
// Good
import 'dart:async';
import 'package:flutter/material.dart';
```

#### Issue: Improper TODO comments
```dart
// Bad
// TODO: Fix this later
```

#### Solution: Follow Flutter style
```dart
// Good
// TODO(username): Fix this later
```

## Automated Fixes

Some issues can be automatically fixed using the following commands:

1. **Fix common issues**:
   ```bash
   dart fix --apply
   ```

2. **Format code**:
   ```bash
   dart format .
   ```

3. **Run our custom analysis script**:
   ```bash
   ./scripts/analyze.sh --fix
   ```

## Manual Fixes Required

Some issues require manual intervention:

1. **Ambiguous imports**: Resolve by using specific imports or renaming classes
2. **Undefined methods**: Fix by using the correct method name or adding the missing method
3. **Inference failures**: Add explicit type annotations where needed
4. **Unused fields**: Either use the field or remove it

## Best Practices

1. **Always run analysis before committing**: Use `./scripts/analyze.sh` to check for issues
2. **Fix issues as you go**: Don't let issues accumulate
3. **Use proper null safety**: Avoid force unwrapping with `!` when possible
4. **Keep code DRY**: Extract common functionality into reusable methods
5. **Follow the Flutter style guide**: Consistent code is easier to maintain

## Continuous Integration

Our CI pipeline runs these checks automatically. Pull requests will fail if they introduce new issues.

To ensure your PR passes CI:

1. Run `./scripts/analyze.sh --fix` locally
2. Fix any remaining issues manually
3. Run `flutter test` to ensure all tests pass
4. Commit and push your changes
