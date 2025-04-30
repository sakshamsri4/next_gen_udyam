#!/bin/bash

# Build script for web
echo "Building Next Gen Udyam for web..."
echo "Using special web entry point with Firebase enabled"

# Build the web version
flutter build web --target=lib/main_web.dart

echo "Build complete!"
