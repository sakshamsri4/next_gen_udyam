#!/bin/bash

# Run tests with coverage
flutter test --coverage

# Check if lcov.info exists
if [ ! -f "coverage/lcov.info" ]; then
  echo "Error: coverage/lcov.info not found. Make sure tests ran successfully."
  exit 1
fi

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Extract coverage percentage
COVERAGE=$(lcov --summary coverage/lcov.info | grep "lines" | awk '{print $4}' | cut -d'%' -f1)
MIN_COVERAGE=90

echo "Current coverage: $COVERAGE%"
echo "Minimum required coverage: $MIN_COVERAGE%"

# Compare with minimum required coverage
if (( $(echo "$COVERAGE < $MIN_COVERAGE" | bc -l) )); then
  echo "Error: Code coverage is below the minimum required coverage."
  echo "Please add more tests to increase coverage."
  exit 1
else
  echo "Code coverage check passed!"
  exit 0
fi
