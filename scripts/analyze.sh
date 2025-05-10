#!/bin/bash

# Script to automate Flutter code analysis and fixes
# Usage: ./scripts/analyze.sh [--fix]

# Set colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print header
echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}   Flutter Code Analysis & Fixes      ${NC}"
echo -e "${BLUE}=======================================${NC}"

# Check if --fix flag is provided
FIX_MODE=false
if [ "$1" == "--fix" ]; then
  FIX_MODE=true
  echo -e "${YELLOW}Running in FIX mode - will attempt to automatically fix issues${NC}"
else
  echo -e "${YELLOW}Running in ANALYZE mode - will only report issues${NC}"
  echo -e "${YELLOW}Use --fix flag to automatically fix issues${NC}"
fi

# Step 1: Run flutter analyze
echo -e "\n${BLUE}Step 1: Running flutter analyze...${NC}"
flutter analyze > analyze_results.txt

# Check if there are any issues
if grep -q "issues found" analyze_results.txt; then
  ISSUES=$(grep "issues found" analyze_results.txt | awk '{print $1}')
  echo -e "${YELLOW}Found $ISSUES issues${NC}"
  
  # Count errors and warnings
  ERRORS=$(grep -c "error" analyze_results.txt)
  WARNINGS=$(grep -c "warning" analyze_results.txt)
  INFOS=$(grep -c "info" analyze_results.txt)
  
  echo -e "${RED}Errors: $ERRORS${NC}"
  echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
  echo -e "${BLUE}Info: $INFOS${NC}"
  
  # Show the most common issues
  echo -e "\n${BLUE}Most common issues:${NC}"
  grep -o "• [^•]*" analyze_results.txt | sort | uniq -c | sort -nr | head -10
  
  # If in fix mode, try to fix issues
  if [ "$FIX_MODE" = true ]; then
    echo -e "\n${BLUE}Step 2: Attempting to fix issues automatically...${NC}"
    
    # Run dart fix
    echo -e "${YELLOW}Running dart fix --apply...${NC}"
    dart fix --apply
    
    # Format code
    echo -e "${YELLOW}Running dart format...${NC}"
    dart format .
    
    # Run analyze again to see if issues were fixed
    echo -e "\n${BLUE}Step 3: Re-analyzing after fixes...${NC}"
    flutter analyze > analyze_results_after.txt
    
    if grep -q "issues found" analyze_results_after.txt; then
      ISSUES_AFTER=$(grep "issues found" analyze_results_after.txt | awk '{print $1}')
      ISSUES_FIXED=$((ISSUES - ISSUES_AFTER))
      
      echo -e "${GREEN}Fixed $ISSUES_FIXED issues${NC}"
      echo -e "${YELLOW}Remaining issues: $ISSUES_AFTER${NC}"
      
      # Count remaining errors and warnings
      ERRORS_AFTER=$(grep -c "error" analyze_results_after.txt)
      WARNINGS_AFTER=$(grep -c "warning" analyze_results_after.txt)
      INFOS_AFTER=$(grep -c "info" analyze_results_after.txt)
      
      echo -e "${RED}Remaining errors: $ERRORS_AFTER${NC}"
      echo -e "${YELLOW}Remaining warnings: $WARNINGS_AFTER${NC}"
      echo -e "${BLUE}Remaining info: $INFOS_AFTER${NC}"
      
      # Show remaining issues
      echo -e "\n${BLUE}Remaining issues:${NC}"
      grep -o "• [^•]*" analyze_results_after.txt | sort | uniq -c | sort -nr | head -10
    else
      echo -e "${GREEN}All issues fixed!${NC}"
    fi
  fi
else
  echo -e "${GREEN}No issues found. Code looks good!${NC}"
fi

# Clean up temporary files
rm -f analyze_results.txt analyze_results_after.txt

echo -e "\n${BLUE}=======================================${NC}"
echo -e "${BLUE}   Analysis Complete                  ${NC}"
echo -e "${BLUE}=======================================${NC}"

# If there are still errors, exit with error code
if [ "$FIX_MODE" = true ] && [ -f analyze_results_after.txt ] && grep -q "error" analyze_results_after.txt; then
  exit 1
elif [ "$FIX_MODE" = false ] && grep -q "error" analyze_results.txt; then
  exit 1
else
  exit 0
fi
