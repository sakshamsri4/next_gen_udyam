#!/bin/bash

# Script to extract potential technical terms from the codebase
# This helps maintain the .cspell.json dictionary

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Extracting potential technical terms from the codebase...${NC}"

# Create a temporary file
TEMP_FILE=$(mktemp)

# Extract camelCase and PascalCase identifiers from Dart files
find lib test -name "*.dart" -type f -exec grep -o '\b[a-z]\+[A-Z][a-zA-Z0-9]*\b' {} \; | sort | uniq > "$TEMP_FILE"

# Extract words with underscores from Dart files
find lib test -name "*.dart" -type f -exec grep -o '\b[a-zA-Z]\+_[a-zA-Z0-9_]\+\b' {} \; | sort | uniq >> "$TEMP_FILE"

# Extract package names from pubspec.yaml
if [[ -f "pubspec.yaml" ]]; then
  grep -A 100 "dependencies:" pubspec.yaml | grep -B 100 -m 1 "^$" | grep "^  [a-zA-Z]" | cut -d ":" -f 1 | tr -d " " >> "$TEMP_FILE"
  grep -A 100 "dev_dependencies:" pubspec.yaml | grep -B 100 -m 1 "^$" | grep "^  [a-zA-Z]" | cut -d ":" -f 1 | tr -d " " >> "$TEMP_FILE"
fi

# Sort and remove duplicates
sort "$TEMP_FILE" | uniq > "${TEMP_FILE}.sorted"

# Count the number of terms
TERM_COUNT=$(wc -l < "${TEMP_FILE}.sorted")
echo -e "${GREEN}Found ${TERM_COUNT} potential technical terms.${NC}"

# Display the terms
echo -e "${YELLOW}Potential technical terms:${NC}"
cat "${TEMP_FILE}.sorted"

# Cleanup
rm "$TEMP_FILE" "${TEMP_FILE}.sorted"

echo -e "${GREEN}Extraction complete.${NC}"
echo -e "${YELLOW}Consider adding these terms to your .cspell.json file if they are valid technical terms.${NC}"
exit 0
