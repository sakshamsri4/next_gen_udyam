#!/bin/bash

# Pre-commit hook to automatically format Dart files
# This script will format all staged Dart files before committing

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running pre-commit hook...${NC}"

# Get all staged Dart files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.dart$')

# Exit if no Dart files are staged
if [[ -z "$STAGED_FILES" ]]; then
  echo -e "${GREEN}No Dart files to format.${NC}"
  exit 0
fi

# Check if dart format is available
if ! command -v dart &> /dev/null; then
  echo -e "${RED}Error: dart command not found.${NC}"
  echo -e "${YELLOW}Please make sure Flutter SDK is installed and in your PATH.${NC}"
  exit 1
fi

echo -e "${YELLOW}Formatting staged Dart files...${NC}"

# Format each staged Dart file
for FILE in $STAGED_FILES; do
  if [[ -f "$FILE" ]]; then
    echo -e "  ${GREEN}Formatting:${NC} $FILE"
    dart format "$FILE" --line-length=80
    git add "$FILE"
  fi
done

echo -e "${GREEN}Pre-commit formatting complete.${NC}"
exit 0
