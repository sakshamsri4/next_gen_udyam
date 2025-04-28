#!/bin/bash

# Script to format all Dart files in the project
# This script will format all Dart files with a line length of 80 characters

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Formatting all Dart files...${NC}"

# Find all Dart files in lib and test directories
DART_FILES=$(find lib test -name "*.dart" 2>/dev/null)

# Exit if no Dart files are found
if [[ -z "$DART_FILES" ]]; then
  echo -e "${YELLOW}No Dart files found in lib or test directories.${NC}"
  exit 0
fi

# Count the number of files
FILE_COUNT=$(echo "$DART_FILES" | wc -l)
echo -e "${YELLOW}Found ${FILE_COUNT} Dart files to format.${NC}"

# Format each Dart file
for FILE in $DART_FILES; do
  if [[ -f "$FILE" ]]; then
    echo -e "  ${GREEN}Formatting:${NC} $FILE"
    dart format "$FILE" --line-length=80
  fi
done

echo -e "${GREEN}Formatting complete.${NC}"
exit 0
