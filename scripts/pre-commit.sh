#!/bin/bash

# Pre-commit hook to run checks before committing
# This script will run various checks to ensure code quality

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running pre-commit hook...${NC}"

# Get list of staged Dart files
STAGED_DART_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.dart$')

# Apply Dart fixes and format Dart files
if [[ -n "$STAGED_DART_FILES" ]]; then
  # Apply Dart fixes - process files one by one
  echo -e "${YELLOW}Applying Dart fixes...${NC}"
  for file in $STAGED_DART_FILES; do
    echo -e "Computing fixes in ${file}..."
    dart fix --apply "$file"
  done

  # Format Dart files
  echo -e "${YELLOW}Formatting Dart files...${NC}"
  echo "$STAGED_DART_FILES" | xargs dart format

  # Re-add the files to staging
  echo "$STAGED_DART_FILES" | xargs git add
  echo -e "${GREEN}Dart files fixed and formatted.${NC}"
else
  echo -e "${YELLOW}No Dart files to fix or format.${NC}"
fi

# Spell check disabled as requested
echo -e "${YELLOW}Spell check has been disabled.${NC}"

exit 0
