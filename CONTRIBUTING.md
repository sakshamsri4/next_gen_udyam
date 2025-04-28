# Contributing to Next Gen

Thank you for your interest in contributing to Next Gen! This document provides guidelines and instructions for contributing to this project.

## Development Environment Setup

### Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (version 3.16.0 or higher)
2. **Dart SDK** (version 3.5.0 or higher)
3. **Node.js and npm** (for spell checking)
4. **cspell** (for spell checking)
   ```sh
   npm install -g cspell
   ```
5. **lcov** (for coverage reports)
   ```sh
   # macOS
   brew install lcov
   
   # Ubuntu/Debian
   sudo apt-get install lcov
   ```

### Setting Up the Project

1. Clone the repository:
   ```sh
   git clone https://github.com/sakshamsri4/next_gen_udyam.git
   cd next_gen_udyam
   ```

2. Set up the project:
   ```sh
   make setup
   ```

## Development Workflow

### Git Hooks

This project uses Git hooks to ensure code quality:

1. **Pre-commit Hook**: Automatically formats Dart files and runs spell check on staged files.
2. **Pre-push Hook**: Runs comprehensive checks before pushing (format, analyze, test, spell check).

### Spell Checking

Spell checking is enforced both locally and in the CI pipeline:

1. The project uses `cspell` for spell checking.
2. Custom technical terms are defined in `.cspell.json`.
3. If you need to add new technical terms, update the `.cspell.json` file.

Example of adding a new term:
```json
{
  "words": [
    "existing-terms",
    "your-new-technical-term"
  ]
}
```

### Code Style

This project follows the [Very Good Analysis](https://pub.dev/packages/very_good_analysis) style guide. Please ensure your code adheres to these guidelines.

### Testing

All code changes should be accompanied by appropriate tests:

1. **Unit Tests**: For testing individual functions and classes.
2. **Widget Tests**: For testing UI components.
3. **Integration Tests**: For testing complete features.

Run tests with:
```sh
make test
```

Check test coverage with:
```sh
make coverage
```

### Pull Request Process

1. Create a feature branch from the main branch:
   ```sh
   make feature name=your-feature-name
   ```

2. Make your changes and commit them with descriptive commit messages.

3. Update the activity log in `docs/activity_log.md` with details about your changes.

4. Push your changes and create a pull request.

5. Ensure all CI checks pass.

6. Wait for code review and address any feedback.

## Troubleshooting

### Common Issues

1. **Spell Check Failures**:
   - Check the error message for unknown words.
   - Add valid technical terms to `.cspell.json`.
   - Fix actual spelling mistakes in your code.

2. **Pre-push Hook Failures**:
   - Make sure you have cspell installed: `npm install -g cspell`.
   - Run `make check` to identify issues before pushing.

3. **Test Failures**:
   - Run `flutter test -v` to see detailed test output.
   - Check for flaky tests that might need to be fixed.

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Very Good Analysis Style Guide](https://pub.dev/packages/very_good_analysis)
- [cspell Documentation](https://cspell.org/)
