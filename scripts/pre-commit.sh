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

# Check for spell checking tool and run it on staged files
if command -v cspell &> /dev/null; then
  STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(dart|md|yaml|json)$')

  if [[ -n "$STAGED_FILES" ]]; then
    echo -e "${YELLOW}Running spell check on staged files...${NC}"
    SPELL_ERRORS=0

    for file in $STAGED_FILES; do
      if ! cspell "$file" --no-progress; then
        SPELL_ERRORS=1
      fi
    done

    if [[ $SPELL_ERRORS -eq 1 ]]; then
      echo -e "${RED}Error: Spell check found issues.${NC}"
      echo -e "${YELLOW}Please fix the spelling issues before committing.${NC}"
      echo -e "${YELLOW}You can add words to .cspell.json if they are valid technical terms.${NC}"
      exit 1
    fi

    echo -e "${GREEN}Spell check passed.${NC}"
  else
    echo -e "${YELLOW}No files to spell check.${NC}"
  fi
else
  echo -e "${YELLOW}cspell not found, skipping spell check.${NC}"
  echo -e "${YELLOW}Consider installing cspell with 'npm install -g cspell' for better quality checks.${NC}"
fi

exit 0
