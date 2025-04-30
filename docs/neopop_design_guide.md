# NeoPOP Design Guide

## Table of Contents

1. [Introduction](#introduction)
2. [Core Design Philosophy](#core-design-philosophy)
3. [Visual Characteristics](#visual-characteristics)
4. [Typography](#typography)
5. [Color System](#color-system)
6. [Component Design](#component-design)
7. [Implementation Guidelines](#implementation-guidelines)
8. [Best Practices](#best-practices)
9. [Resources](#resources)

## Introduction

This guide outlines the design principles and implementation guidelines for the NeoPOP design system in our Flutter application. NeoPOP is a design system inspired by CRED's approach, focusing on creating beautiful, physical, and delightful user interfaces.

## Core Design Philosophy

NeoPOP's design philosophy centers around several key principles:

### Beauty as the Central Goal

- **Performance**: Fast, responsive interfaces are beautiful
- **Joy**: Creating moments of delight at every step
- **Reliability**: Experiences that work consistently
- **Artistry**: Interfaces crafted with attention to detail
- **Functionality**: Intuitive experiences that exceed user expectations

### Key Principles

1. **Bold and Colorful**: Vibrant colors and strong visual elements
2. **Physical and Tangible**: Design that mimics real-world objects and interactions
3. **Consistent yet Diverse**: Unified experience across different product categories
4. **Delightful Interactions**: Focus on creating moments of joy through interaction
5. **Component-Based**: Modular design system for scalability and consistency

## Visual Characteristics

- **Elevated Elements**: Buttons and cards with visible depth and dimension
- **Strong Shadows**: Pronounced shadows to create a sense of physicality
- **High Contrast**: Bold color combinations for visual impact
- **Generous Spacing**: Ample negative space to highlight important elements
- **Layered Interfaces**: Multiple visual planes to create hierarchy

## Typography

### Font System

- **Primary Font**: Cirka (for headlines and emphasis)
- **Secondary Font**: Inter (for body text and UI elements)

### Type Scale

| Name | Size (px) | Weight | Line Height | Usage |
|------|-----------|--------|-------------|-------|
| Display | 48px | Bold (700) | 1.2 | Hero sections, major headlines |
| Heading 1 | 32px | Bold (700) | 1.25 | Section titles, screen headers |
| Heading 2 | 24px | Bold (700) | 1.3 | Sub-sections, card headers |
| Heading 3 | 20px | SemiBold (600) | 1.4 | Minor headings, feature titles |
| Body Large | 18px | Regular (400) | 1.5 | Primary content, important information |
| Body | 16px | Regular (400) | 1.5 | Standard body text |
| Body Small | 14px | Regular (400) | 1.5 | Secondary information, captions |
| Caption | 12px | Regular (400) | 1.5 | Labels, timestamps, footnotes |
| Button | 16px | Bold (700) | 1.25 | Button text |

### Typography Guidelines

1. **Contrast**: Maintain a minimum contrast ratio of 4.5:1 for body text and 3:1 for large text
2. **Alignment**: Use left alignment for most text (RTL languages will automatically mirror)
3. **Case**: Use sentence case for body text and title case for headings and buttons
4. **Line Length**: Aim for 50-75 characters per line for optimal readability

## Color System

### Primary Colors

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| Navy Blue | `#0A1126` | `10, 17, 38` | Primary background |
| Electric Blue | `#3D63FF` | `61, 99, 255` | Primary buttons, key actions |
| Mint Green | `#00A651` | `0, 166, 81` | Success states, confirmations |
| Coral Red | `#E63946` | `230, 57, 70` | Error states, destructive actions |
| Pure White | `#FFFFFF` | `255, 255, 255` | Text, highlights |

### Secondary Colors

| Color Name | Hex Code | RGB | Usage |
|------------|----------|-----|-------|
| Slate Gray | `#6C757D` | `108, 117, 125` | Secondary text, disabled states |
| Lavender | `#7F5AF0` | `127, 90, 240` | Accent elements, highlights |
| Teal | `#2EC4B6` | `46, 196, 182` | Alternative accent, progress indicators |
| Amber | `#FF9F1C` | `255, 159, 28` | Warnings, attention-grabbing elements |
| Light Gray | `#F8F9FA` | `248, 249, 250` | Background for cards, secondary areas |

## Component Design

### NeoPOP Button

The `NeoPopButton` is the cornerstone of the NeoPOP design system, providing a physical, elevated button with various customization options.

#### Button Elevation

For NeoPOP buttons, use the following depth settings:

| Importance | Depth Value | Usage |
|------------|-------------|-------|
| Primary | 8-10 | Main call-to-action buttons |
| Secondary | 5-7 | Standard action buttons |
| Tertiary | 2-4 | Less important actions |
| Flat | 0 | Subtle or text buttons |

## Implementation Guidelines

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

### Basic Button Implementation

```dart
NeoPopButton(
  color: Colors.blue,
  onTap: () => print('Button pressed'),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: Text('NeoPOP Button'),
  ),
)
```

### Customizing Elevation

```dart
NeoPopButton(
  color: Colors.blue,
  depth: 10, // Customize the button depth
  onTap: () => print('Button pressed'),
  child: Text('Deep Button'),
)
```

### Adding Borders

```dart
NeoPopButton(
  color: Colors.blue,
  border: Border.all(color: Colors.white, width: 2),
  onTap: () => print('Button pressed'),
  child: Text('Bordered Button'),
)
```

### Creating Shimmer Effects

```dart
NeoPopButton(
  color: Colors.blue,
  shimmer: true,
  onTap: () => print('Button pressed'),
  child: Text('Shimmer Button'),
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

### Layout

1. **Proper Spacing**: Maintain consistent spacing between buttons
2. **Alignment**: Align buttons consistently within their containers
3. **Hierarchy**: Use size, color, and position to establish button hierarchy

### Performance Considerations

1. **Limit Animations**: Use shimmer effects sparingly to avoid performance issues
2. **Optimize Rebuilds**: Avoid unnecessary widget rebuilds that include NeoPOP buttons
3. **Test on Real Devices**: Always test on real devices to ensure smooth performance

## Resources

- [NeoPOP Flutter Package](https://pub.dev/packages/neopop)
- [NeoPOP GitHub Repository](https://github.com/CRED-CLUB/neopop-flutter)
- [CRED Design Website](https://design.cred.club/)

---

This guide provides practical instructions for using the NeoPOP design system in our Flutter application. By following these guidelines, we can create a consistent, beautiful, and engaging user experience.
