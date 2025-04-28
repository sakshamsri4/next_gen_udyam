#!/bin/bash

# Pre-push hook to run checks before pushing
# This script will run various checks to ensure code quality

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Running pre-push checks...${NC}"

# Get the current branch name
BRANCH_NAME=$(git symbolic-ref --short HEAD)

# Prevent direct pushes to main branch
if [[ "$BRANCH_NAME" == "main" || "$BRANCH_NAME" == "master" ]]; then
  echo -e "${RED}Error: Direct push to $BRANCH_NAME branch is not allowed.${NC}"
  echo -e "${YELLOW}Please create a feature branch and submit a pull request instead.${NC}"
  exit 1
fi

# Check if activity log has been updated
ACTIVITY_LOG="docs/activity_log.md"
if [[ -f "$ACTIVITY_LOG" ]]; then
  # Check if the activity log has been modified
  if ! git diff --name-only --cached | grep -q "$ACTIVITY_LOG"; then
    # Check if there are code changes
    CODE_CHANGES=$(git diff --name-only --cached | grep -E '\.(dart|yaml|json|md)$' | grep -v "$ACTIVITY_LOG")
    if [[ -n "$CODE_CHANGES" ]]; then
      echo -e "${RED}Warning: You have code changes but haven't updated the activity log.${NC}"
      echo -e "${YELLOW}Changed files:${NC}"
      echo "$CODE_CHANGES"
      echo -e "${YELLOW}Please update $ACTIVITY_LOG before pushing.${NC}"
      echo -e "${YELLOW}Remember to include:${NC}"
      echo -e "  - ${GREEN}What${NC} changes were made"
      echo -e "  - ${GREEN}Why${NC} the changes were necessary"
      echo -e "  - ${GREEN}How${NC} the solution works"
      echo -e "  - Any ${GREEN}lessons learned${NC} or ${GREEN}best practices${NC} applied"

      # Ask for confirmation
      read -p "Do you want to continue without updating the activity log? (y/N) " -n 1 -r
      echo
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
      fi
    fi
  fi
fi

# Run Flutter format check
echo -e "${YELLOW}Running Flutter format check...${NC}"
if ! dart format --output=none --set-exit-if-changed . ; then
  echo -e "${RED}Error: Code formatting issues found.${NC}"
  echo -e "${YELLOW}Please run 'dart format .' to fix formatting issues.${NC}"
  exit 1
fi
echo -e "${GREEN}Format check passed.${NC}"

# Run Flutter analyze
echo -e "${YELLOW}Running Flutter analyze...${NC}"
if ! flutter analyze ; then
  echo -e "${RED}Error: Flutter analyze found issues.${NC}"
  echo -e "${YELLOW}Please fix the issues before pushing.${NC}"
  exit 1
fi
echo -e "${GREEN}Analyze passed.${NC}"

# Run Flutter tests
echo -e "${YELLOW}Running Flutter tests...${NC}"
if ! flutter test ; then
  echo -e "${RED}Error: Tests failed.${NC}"
  echo -e "${YELLOW}Please fix the failing tests before pushing.${NC}"
  exit 1
fi
echo -e "${GREEN}Tests passed.${NC}"

# Check for spell checking tool
if command -v cspell &> /dev/null; then
  echo -e "${YELLOW}Running spell check...${NC}"
  if ! cspell "**/*.{dart,md,yaml,json}" --no-progress ; then
    echo -e "${RED}Error: Spell check found issues.${NC}"
    echo -e "${YELLOW}Please fix the spelling issues before pushing.${NC}"
    exit 1
  fi
  echo -e "${GREEN}Spell check passed.${NC}"
else
  echo -e "${YELLOW}cspell not found, skipping spell check.${NC}"
  echo -e "${YELLOW}Consider installing cspell with 'npm install -g cspell' for better quality checks.${NC}"
fi

echo -e "${GREEN}All pre-push checks passed!${NC}"
exit 0
