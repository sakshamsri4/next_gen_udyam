#!/bin/bash

# Run all tests and generate coverage report
run_tests() {
  echo "Running all tests..."
  flutter test --coverage
  
  if [ $? -eq 0 ]; then
    echo "All tests passed!"
    
    # Generate coverage report if lcov is installed
    if command -v genhtml >/dev/null 2>&1; then
      echo "Generating coverage report..."
      genhtml coverage/lcov.info -o coverage/html
      echo "Coverage report generated at coverage/html/index.html"
      
      # Open coverage report if open command is available
      if command -v open >/dev/null 2>&1; then
        echo "Opening coverage report in browser..."
        open coverage/html/index.html
      fi
    else
      echo "genhtml not found. Install lcov to generate HTML reports."
    fi
  else
    echo "Tests failed!"
    exit 1
  fi
}

# Run specific test file
run_specific_test() {
  local test_file=$1
  echo "Running test: $test_file"
  flutter test "$test_file"
}

# Run tests with specific tag
run_tagged_tests() {
  local tag=$1
  echo "Running tests with tag: $tag"
  flutter test --tags "$tag"
}

# Check code coverage
check_coverage() {
  echo "Checking code coverage..."
  ./scripts/check_coverage.sh
}

# Run all code quality checks
run_code_quality_checks() {
  echo "Running code quality checks..."
  
  echo "Running flutter analyze..."
  flutter analyze
  
  echo "Running dart fix --dry-run..."
  dart fix --dry-run
  
  echo "Running dart format --output=none --set-exit-if-changed ."
  dart format --output=none --set-exit-if-changed .
}

# Apply code fixes
apply_code_fixes() {
  echo "Applying code fixes..."
  dart fix --apply
}

# Format code
format_code() {
  echo "Formatting code..."
  dart format .
}

# Main function
main() {
  case "$1" in
    "all")
      run_tests
      ;;
    "file")
      if [ -z "$2" ]; then
        echo "Error: No test file specified"
        echo "Usage: $0 file <test_file>"
        exit 1
      fi
      run_specific_test "$2"
      ;;
    "tag")
      if [ -z "$2" ]; then
        echo "Error: No tag specified"
        echo "Usage: $0 tag <tag>"
        exit 1
      fi
      run_tagged_tests "$2"
      ;;
    "coverage")
      check_coverage
      ;;
    "quality")
      run_code_quality_checks
      ;;
    "fix")
      apply_code_fixes
      ;;
    "format")
      format_code
      ;;
    *)
      echo "Usage: $0 {all|file|tag|coverage|quality|fix|format}"
      echo "  all       - Run all tests and generate coverage report"
      echo "  file FILE - Run specific test file"
      echo "  tag TAG   - Run tests with specific tag"
      echo "  coverage  - Check code coverage"
      echo "  quality   - Run code quality checks"
      echo "  fix       - Apply code fixes"
      echo "  format    - Format code"
      exit 1
      ;;
  esac
}

# Run main function
main "$@"
