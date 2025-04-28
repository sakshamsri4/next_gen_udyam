#!/bin/bash

# Script to generate app icons for all platforms
# This script uses flutter_launcher_icons package to generate icons

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Generating app icons for all platforms...${NC}"

# Check if flutter_launcher_icons is in pubspec.yaml
if ! grep -q "flutter_launcher_icons" pubspec.yaml; then
  echo -e "${YELLOW}Adding flutter_launcher_icons to pubspec.yaml...${NC}"
  # Add flutter_launcher_icons to dev_dependencies
  if grep -q "dev_dependencies:" pubspec.yaml; then
    # Add after dev_dependencies
    sed -i '' '/dev_dependencies:/a\
  flutter_launcher_icons: ^0.13.1
' pubspec.yaml
  else
    echo -e "${RED}Error: Could not find dev_dependencies in pubspec.yaml${NC}"
    exit 1
  fi
  
  # Run flutter pub get
  echo -e "${YELLOW}Running flutter pub get...${NC}"
  flutter pub get
fi

# Check if flutter_launcher_icons.yaml exists
if [ ! -f "flutter_launcher_icons.yaml" ]; then
  echo -e "${YELLOW}Creating flutter_launcher_icons.yaml...${NC}"
  cat > flutter_launcher_icons.yaml << EOL
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/app_icon/app_icon.png"
  min_sdk_android: 21
  web:
    generate: true
    image_path: "assets/app_icon/app_icon.png"
    background_color: "#hexcode"
    theme_color: "#hexcode"
  windows:
    generate: true
    image_path: "assets/app_icon/app_icon.png"
    icon_size: 48
  macos:
    generate: true
    image_path: "assets/app_icon/app_icon.png"
EOL
fi

# Check if app icon directory exists
if [ ! -d "assets/app_icon" ]; then
  echo -e "${YELLOW}Creating assets/app_icon directory...${NC}"
  mkdir -p assets/app_icon
  
  echo -e "${YELLOW}Please add your app icon to assets/app_icon/app_icon.png${NC}"
  echo -e "${YELLOW}Then run this script again.${NC}"
  exit 0
fi

# Check if app icon exists
if [ ! -f "assets/app_icon/app_icon.png" ]; then
  echo -e "${RED}Error: app_icon.png not found in assets/app_icon/${NC}"
  echo -e "${YELLOW}Please add your app icon to assets/app_icon/app_icon.png${NC}"
  exit 1
fi

# Generate icons
echo -e "${YELLOW}Running flutter_launcher_icons...${NC}"
flutter pub run flutter_launcher_icons

echo -e "${GREEN}App icons generated successfully!${NC}"
echo -e "${YELLOW}Icons have been generated for Android, iOS, Web, Windows, and macOS.${NC}"
exit 0
