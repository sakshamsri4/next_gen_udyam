# NeoPOP Style Guide

## Table of Contents

1. [Introduction](#introduction)
2. [Color Palette](#color-palette)
3. [Typography](#typography)
4. [Spacing and Layout](#spacing-and-layout)
5. [Elevation and Shadows](#elevation-and-shadows)
6. [Component Styling](#component-styling)
7. [Animation Guidelines](#animation-guidelines)

## Introduction

This style guide defines the visual language for our implementation of the NeoPOP design system. It provides specific guidelines for colors, typography, spacing, and other visual elements to ensure a consistent and beautiful user experience.

## Color Palette

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

### Gradient Combinations

| Gradient Name | Colors | Usage |
|---------------|--------|-------|
| Blue Gradient | `#3D63FF` to `#5D83FF` | Primary buttons, CTAs |
| Success Gradient | `#00A651` to `#00C167` | Success states, completion indicators |
| Warning Gradient | `#FF9F1C` to `#FFBF69` | Warning states, caution indicators |
| Error Gradient | `#E63946` to `#FF5A67` | Error states, critical alerts |

## Typography

### Font Families

1. **Primary Font**: Cirka (for headlines and emphasis)
   - If Cirka is not available, use a similar serif font like Georgia

2. **Secondary Font**: Inter (for body text and UI elements)
   - If Inter is not available, use a system sans-serif font

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

## Spacing and Layout

### Spacing Scale

| Name | Size (px) | Usage |
|------|-----------|-------|
| Micro | 4px | Minimal spacing, icon padding |
| Tiny | 8px | Close elements, internal padding |
| Small | 16px | Standard spacing between related elements |
| Medium | 24px | Spacing between distinct elements |
| Large | 32px | Section spacing, major separations |
| XLarge | 48px | Screen padding, major section breaks |
| XXLarge | 64px | Hero spacing, dramatic separations |

### Layout Grid

- **Base Unit**: 8px
- **Columns**: 4 columns on mobile, 8 columns on tablet, 12 columns on desktop
- **Gutters**: 16px on mobile, 24px on tablet, 32px on desktop
- **Margins**: 16px on mobile, 32px on tablet, 64px on desktop

### Component Spacing

| Component | Internal Padding | External Margin |
|-----------|------------------|----------------|
| Buttons | 16px vertical, 24px horizontal | 16px from other elements |
| Cards | 24px | 16px from other cards, 24px from screen edge |
| Form Fields | 12px vertical, 16px horizontal | 16px between fields |
| Lists | 16px between items | 24px from other elements |
| Modals | 24px internal, 32px for header/footer | 32px from screen edge |

## Elevation and Shadows

### Elevation Levels

| Level | Usage | Shadow Properties |
|-------|-------|------------------|
| 0 | Flat elements, backgrounds | No shadow |
| 1 | Cards, subtle elevation | `offset-x: 0, offset-y: 2px, blur: 4px, spread: 0, opacity: 0.1` |
| 2 | Raised elements, buttons | `offset-x: 0, offset-y: 4px, blur: 8px, spread: 0, opacity: 0.15` |
| 3 | Floating elements, dialogs | `offset-x: 0, offset-y: 8px, blur: 16px, spread: 0, opacity: 0.2` |
| 4 | Popovers, dropdowns | `offset-x: 0, offset-y: 12px, blur: 24px, spread: 0, opacity: 0.25` |
| 5 | Modals, top-level elements | `offset-x: 0, offset-y: 16px, blur: 32px, spread: 0, opacity: 0.3` |

### NeoPOP Button Elevation

For NeoPOP buttons, use the following depth settings:

| Importance | Depth Value | Usage |
|------------|-------------|-------|
| Primary | 8-10 | Main call-to-action buttons |
| Secondary | 5-7 | Standard action buttons |
| Tertiary | 2-4 | Less important actions |
| Flat | 0 | Subtle or text buttons |

## Component Styling

### Buttons

#### Primary Button

```dart
NeoPopButton(
  color: const Color(0xFF3D63FF),
  depth: 8,
  onTap: () {},
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Text(
      'PRIMARY',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  ),
)
```

#### Secondary Button

```dart
NeoPopButton(
  color: const Color(0xFF6C757D),
  depth: 5,
  onTap: () {},
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Text(
      'SECONDARY',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  ),
)
```

#### Tertiary Button

```dart
NeoPopButton(
  color: Colors.transparent,
  depth: 0,
  border: Border.all(color: const Color(0xFF3D63FF), width: 2),
  onTap: () {},
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Text(
      'TERTIARY',
      style: TextStyle(
        color: const Color(0xFF3D63FF),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  ),
)
```

### Cards

```dart
Container(
  margin: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        offset: const Offset(0, 4),
        blurRadius: 8,
      ),
    ],
  ),
  child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Title',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Card content goes here. This is a standard card component with proper spacing and elevation.',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    ),
  ),
)
```

### Form Fields

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Input Label',
    hintText: 'Enter text here',
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: const Color(0xFF6C757D)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: const Color(0xFF6C757D)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: const Color(0xFF3D63FF), width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
)
```

## Animation Guidelines

### Duration

| Type | Duration (ms) | Usage |
|------|--------------|-------|
| Instant | 100 | Micro-interactions, button presses |
| Quick | 200 | Standard transitions, feedback |
| Standard | 300 | Page transitions, component animations |
| Elaborate | 500 | Complex animations, emphasis |

### Easing Curves

| Type | Curve | Usage |
|------|-------|-------|
| Standard | `Curves.easeInOut` | Most transitions |
| Entry | `Curves.easeOut` | Elements entering the screen |
| Exit | `Curves.easeIn` | Elements exiting the screen |
| Emphasis | `Curves.elasticOut` | Attention-grabbing animations |

### Animation Principles

1. **Timing**: Use appropriate timing for different types of animations
2. **Direction**: Maintain consistent direction for similar animations
3. **Hierarchy**: Use animation to reinforce visual hierarchy
4. **Purpose**: Every animation should serve a purpose (feedback, transition, attention)

---

This style guide provides specific visual guidelines for implementing the NeoPOP design system in our application. By following these guidelines, we can create a consistent, beautiful, and engaging user experience that aligns with CRED's design principles.
