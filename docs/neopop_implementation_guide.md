# NeoPOP Implementation Guide

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [Basic Components](#basic-components)
4. [Advanced Techniques](#advanced-techniques)
5. [Best Practices](#best-practices)
6. [Examples](#examples)
7. [Troubleshooting](#troubleshooting)

## Introduction

This guide provides practical instructions for implementing the NeoPOP design system in our Flutter application. NeoPOP is a design system inspired by CRED's approach, focusing on creating beautiful, physical, and delightful user interfaces.

## Getting Started

### Installation

Add the NeoPOP package to your `pubspec.yaml`:

```yaml
dependencies:
  neopop: ^1.0.2
```

Then run:

```bash
flutter pub get
```

### Basic Setup

Import the package in your Dart files:

```dart
import 'package:neopop/neopop.dart';
```

## Basic Components

### NeoPOP Button

The `NeoPopButton` is the cornerstone of the NeoPOP design system, providing a physical, elevated button with various customization options.

#### Basic Button

```dart
NeoPopButton(
  color: Colors.blue,
  onTap: () {
    // Handle tap
  },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: Text(
      'Basic Button',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),
)
```

#### Button with Custom Depth

```dart
NeoPopButton(
  color: Colors.blue,
  depth: 10, // Default is 5
  onTap: () {
    // Handle tap
  },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: Text(
      'Deep Button',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),
)
```

#### Button with Border

```dart
NeoPopButton(
  color: Colors.blue,
  border: Border.all(color: Colors.white, width: 2),
  onTap: () {
    // Handle tap
  },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: Text(
      'Bordered Button',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),
)
```

#### Flat Button

```dart
NeoPopButton(
  color: Colors.blue,
  depth: 0, // Zero depth for flat appearance
  onTap: () {
    // Handle tap
  },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: Text(
      'Flat Button',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),
)
```

### Shimmer Effect

Add a shimmer effect to create a more dynamic and engaging button:

```dart
NeoPopButton(
  color: Colors.blue,
  shimmer: true,
  onTap: () {
    // Handle tap
  },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: Text(
      'Shimmer Button',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),
)
```

### Button Positioning

Control the button's position relative to its parent:

```dart
NeoPopButton(
  color: Colors.blue,
  buttonPosition: Position.bottomRight, // Options: topLeft, topRight, bottomLeft, bottomRight, center
  onTap: () {
    // Handle tap
  },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: Text(
      'Positioned Button',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),
)
```

### Parent Color

Specify the parent container's color for proper shadow rendering:

```dart
Container(
  color: Colors.grey[200],
  child: NeoPopButton(
    color: Colors.blue,
    parentColor: Colors.grey[200],
    onTap: () {
      // Handle tap
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Text(
        'Button with Parent Color',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  ),
)
```

## Advanced Techniques

### Creating Adjacent Buttons

Place buttons next to each other with proper spacing:

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    NeoPopButton(
      color: Colors.blue,
      onTap: () {
        // Handle left button tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text(
          'Left',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    const SizedBox(width: 20), // Spacing between buttons
    NeoPopButton(
      color: Colors.red,
      onTap: () {
        // Handle right button tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text(
          'Right',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ],
)
```

### Vertical Button Stack

Create a vertical stack of buttons:

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    NeoPopButton(
      color: Colors.blue,
      onTap: () {
        // Handle top button tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text(
          'Top Button',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    const SizedBox(height: 20), // Spacing between buttons
    NeoPopButton(
      color: Colors.green,
      onTap: () {
        // Handle bottom button tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text(
          'Bottom Button',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ],
)
```

### Custom Button Content

Create buttons with icons or complex content:

```dart
NeoPopButton(
  color: Colors.purple,
  onTap: () {
    // Handle tap
  },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, color: Colors.white),
        SizedBox(width: 8),
        Text(
          'Button with Icon',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  ),
)
```

### Disabled State

Create a disabled button:

```dart
NeoPopButton(
  color: Colors.grey,
  enabled: false, // Disable the button
  onTap: () {
    // This won't be called when disabled
  },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: Text(
      'Disabled Button',
      style: TextStyle(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.bold),
    ),
  ),
)
```

## Best Practices

### Color Selection

1. **High Contrast**: Use high-contrast color combinations for better visibility
2. **Consistent Palette**: Maintain a consistent color palette throughout the app
3. **Meaningful Colors**: Use colors to convey meaning (e.g., blue for primary actions, red for destructive actions)

### Button Sizing

1. **Comfortable Touch Targets**: Make buttons at least 48x48 pixels for easy tapping
2. **Consistent Sizing**: Use consistent button sizes for similar actions
3. **Proportional Padding**: Apply padding proportional to the button's size

### Typography

1. **Readable Text**: Ensure text has sufficient contrast against the button color
2. **Consistent Fonts**: Use the same font family throughout the app
3. **Appropriate Weight**: Use bold text for buttons to enhance visibility

### Layout

1. **Proper Spacing**: Maintain consistent spacing between buttons
2. **Alignment**: Align buttons consistently within their containers
3. **Hierarchy**: Use size, color, and position to establish button hierarchy

## Examples

### Login Button

```dart
NeoPopButton(
  color: const Color(0xFF3D63FF),
  onTap: () {
    // Handle login
  },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    child: Text(
      'LOG IN',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  ),
)
```

### Payment Button

```dart
NeoPopButton(
  color: const Color(0xFF00A651),
  shimmer: true,
  onTap: () {
    // Handle payment
  },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.payment, color: Colors.white),
        SizedBox(width: 8),
        Text(
          'PAY NOW',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ),
  ),
)
```

### Cancel Button

```dart
NeoPopButton(
  color: const Color(0xFFE63946),
  depth: 0, // Flat appearance for secondary actions
  border: Border.all(color: Colors.white, width: 1),
  onTap: () {
    // Handle cancel
  },
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    child: Text(
      'CANCEL',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  ),
)
```

## Troubleshooting

### Common Issues

#### Button Shadow Not Visible

**Problem**: The button shadow is not visible or appears incorrect.

**Solution**: Ensure you've set the correct `parentColor` that matches the actual background color of the parent container.

```dart
NeoPopButton(
  color: Colors.blue,
  parentColor: Colors.grey[200], // Must match the actual background
  onTap: () {},
  child: Text('Button'),
)
```

#### Button Not Responding to Taps

**Problem**: The button doesn't respond when tapped.

**Solution**: Check if the button is disabled or if there's an issue with the tap area.

```dart
NeoPopButton(
  color: Colors.blue,
  enabled: true, // Ensure this is true
  onTap: () {
    print('Button tapped'); // Add debug print to verify
  },
  child: Padding(
    padding: const EdgeInsets.all(15), // Add sufficient padding for tap area
    child: Text('Button'),
  ),
)
```

#### Shimmer Effect Not Working

**Problem**: The shimmer effect is not visible on the button.

**Solution**: Ensure the shimmer property is set to true and the button has sufficient size.

```dart
NeoPopButton(
  color: Colors.blue,
  shimmer: true,
  onTap: () {},
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    child: Text('Shimmer Button'),
  ),
)
```

### Performance Considerations

1. **Limit Animations**: Use shimmer effects sparingly to avoid performance issues
2. **Optimize Rebuilds**: Avoid unnecessary widget rebuilds that include NeoPOP buttons
3. **Test on Real Devices**: Always test on real devices to ensure smooth performance

---

This implementation guide provides practical instructions for using the NeoPOP design system in our Flutter application. By following these guidelines, we can create a consistent, beautiful, and engaging user experience.
