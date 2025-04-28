# CRED Design Guide

## Table of Contents

1. [Introduction](#introduction)
2. [Core Design Philosophy](#core-design-philosophy)
3. [Design Evolution](#design-evolution)
4. [NeoPOP Design System](#neopop-design-system)
5. [Typography](#typography)
6. [Color System](#color-system)
7. [Component Design](#component-design)
8. [Motion and Animation](#motion-and-animation)
9. [Illustrations and Icons](#illustrations-and-icons)
10. [Implementation Guidelines](#implementation-guidelines)
11. [Resources](#resources)

## Introduction

This guide outlines the design principles and implementation guidelines based on CRED's design philosophy. CRED has established itself as a leader in creating beautiful, functional, and delightful digital experiences. By adopting these principles, we aim to create a similarly engaging and aesthetically pleasing experience for our users.

## Core Design Philosophy

CRED's design philosophy centers around several key principles:

### Beauty as the Central Goal

> "To build the most beautiful digital experience for our members. Something that works efficiently with a deep focus on creating moments of delight."

Beauty in design extends beyond aesthetics:
- **Performance**: Fast, responsive interfaces are beautiful
- **Joy**: Creating moments of delight at every step
- **Reliability**: Experiences that work consistently
- **Artistry**: Interfaces crafted with attention to detail
- **Functionality**: Intuitive experiences that exceed user expectations

### Art at the Heart of Design

> "Design should inspire creativity, design should bring out emotions, design should delight, design should seek a purpose beyond the most obvious."

Design should:
- Inspire creativity
- Evoke emotions
- Create delight
- Serve purposes beyond the obvious
- Connect with users on a human level

### Balance of Form and Function

The perfect balance between:
- Aesthetic appeal
- Functional efficiency
- Technical performance
- Emotional connection

## Design Evolution

CRED's design has evolved through four major systems, each with distinct characteristics:

### 1. Topaz (2018)
- **Style**: Minimalist, illustrative
- **Characteristics**:
  - Flat and reductionist minimalism
  - Typography highlighting numbers
  - High-performance payment system
  - Sci-fi inspired illustrations ("Cyborg")
  - Advanced Lottie-based animations

### 2. Fabrik (2019)
- **Style**: Bold, skeuomorphic
- **Characteristics**:
  - More advanced design constructs
  - Improved navigation and exploration
  - Skeuomorphic card designs
  - Enhanced statements feature
  - High-fidelity bespoke merchandising

### 3. Copper (2020)
- **Style**: Neumorphism, physical
- **Characteristics**:
  - First commercial implementation of neumorphism
  - Fully customizable, backend driven system
  - Hyper-componentized design system
  - Physical metaphor-driven UI
  - "Synth" UI library

### 4. NeoPOP (Current)
- **Style**: Bold, colorful, physical
- **Characteristics**:
  - Inspired by the NeoPOP art movement
  - Combines isometrics, linear motion, and pseudo-morphism
  - Multi-genre product support
  - Consistent design across diverse product offerings
  - Open-source library

## NeoPOP Design System

The NeoPOP design system is CRED's current approach, characterized by:

### Key Principles

1. **Bold and Colorful**: Vibrant colors and strong visual elements
2. **Physical and Tangible**: Design that mimics real-world objects and interactions
3. **Consistent yet Diverse**: Unified experience across different product categories
4. **Delightful Interactions**: Focus on creating moments of joy through interaction
5. **Component-Based**: Modular design system for scalability and consistency

### Visual Characteristics

- **Elevated Elements**: Buttons and cards with visible depth and dimension
- **Strong Shadows**: Pronounced shadows to create a sense of physicality
- **High Contrast**: Bold color combinations for visual impact
- **Generous Spacing**: Ample negative space to highlight important elements
- **Layered Interfaces**: Multiple visual planes to create hierarchy

## Typography

### Font System

- **Primary Font**: Cirka (for headlines and emphasis)
- **Secondary Font**: System font for readability in body text
- **Numeric Display**: Special attention to number presentation

### Typography Guidelines

1. **Hierarchy**: Clear typographic hierarchy with distinct styles for:
   - Headlines
   - Subheadings
   - Body text
   - Labels
   - Numbers and data

2. **Weight Contrast**: Use of contrasting font weights to create visual interest

3. **Size Scale**: Consistent type scale with appropriate increments

4. **Alignment**: Primarily left-aligned text for readability

## Color System

### Primary Palette

- **Deep Navy**: Primary background color
- **White**: Primary text and highlight color
- **Vibrant Accent Colors**: Used sparingly for emphasis and interaction

### Color Usage Guidelines

1. **High Contrast**: Maintain strong contrast for readability
2. **Purposeful Color**: Use color to guide attention and indicate state
3. **Consistent Application**: Apply colors consistently across similar elements
4. **Accessibility**: Ensure color combinations meet accessibility standards

## Component Design

### Buttons

> "Buttons that you can't resist: high contrast, accessible, haptic-aware, multi-state, multi-elevation buttons."

- **Elevation**: Multiple levels of elevation to indicate importance
- **States**: Clear visual distinction between states (normal, hover, pressed, disabled)
- **Haptic Feedback**: Coordinated with visual feedback for physical sensation
- **Contrast**: High contrast with background for visibility

### Cards

- **Physical Appearance**: Cards that appear to have real depth and weight
- **Elevation Levels**: Different elevation levels to indicate hierarchy
- **Interaction**: Clear interaction patterns (tap, swipe, etc.)
- **Content Organization**: Structured layout with clear information hierarchy

### Navigation

- **Intuitive Flow**: Natural progression through the app
- **Visual Cues**: Clear indicators of current location and available actions
- **Consistent Patterns**: Familiar navigation patterns across the app

### Forms and Inputs

- **Minimalist Design**: Clean, focused input fields
- **Clear Feedback**: Immediate visual feedback on interaction
- **Error States**: Helpful error messages with visual indicators
- **Progressive Disclosure**: Reveal information as needed

## Motion and Animation

### Animation Principles

1. **Purpose-Driven**: Animations serve a functional purpose
2. **Natural Physics**: Movements follow natural physics (easing, gravity)
3. **Subtle but Noticeable**: Refined animations that enhance without distracting
4. **Consistent Timing**: Standardized duration for similar animations

### Animation Types

- **Transitions**: Smooth transitions between states and screens
- **Feedback**: Immediate visual feedback for user actions
- **Attention**: Guiding user attention to important elements
- **Delight**: Creating moments of joy through unexpected animations

## Illustrations and Icons

### Illustration Style

- **Bold and Colorful**: Vibrant, eye-catching illustrations
- **Isometric**: 3D perspective for depth and dimension
- **Conceptual**: Abstract representations of complex concepts
- **Consistent Character**: Unified style across all illustrations

### Icon System

- **Distinctive Style**: Unique icon style that aligns with the overall design
- **Consistent Grid**: Icons built on a consistent grid system
- **Meaningful**: Icons that clearly communicate their purpose
- **Scalable**: Icons that work at various sizes

## Implementation Guidelines

### Using the NeoPOP Library

1. **Installation**:
   ```bash
   flutter pub add neopop
   ```

2. **Basic Button Implementation**:
   ```dart
   import 'package:neopop/neopop.dart';

   NeoPopButton(
     color: Colors.blue,
     onTap: () => print('Button pressed'),
     child: Padding(
       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
       child: Text('NeoPOP Button'),
     ),
   )
   ```

3. **Customizing Elevation**:
   ```dart
   NeoPopButton(
     color: Colors.blue,
     depth: 10, // Customize the button depth
     onTap: () => print('Button pressed'),
     child: Text('Deep Button'),
   )
   ```

4. **Adding Borders**:
   ```dart
   NeoPopButton(
     color: Colors.blue,
     border: Border.all(color: Colors.white, width: 2),
     onTap: () => print('Button pressed'),
     child: Text('Bordered Button'),
   )
   ```

5. **Creating Shimmer Effects**:
   ```dart
   NeoPopButton(
     color: Colors.blue,
     shimmer: true,
     onTap: () => print('Button pressed'),
     child: Text('Shimmer Button'),
   )
   ```

### Design Principles in Practice

1. **Information Hierarchy**:
   - Place the most important information at the top or in focus
   - Use size, color, and position to indicate importance
   - Group related information together

2. **Spacing and Layout**:
   - Use consistent spacing throughout the app
   - Implement a grid system for alignment
   - Allow for generous negative space

3. **Interaction Design**:
   - Provide immediate feedback for all interactions
   - Ensure touch targets are appropriately sized
   - Create smooth transitions between states

4. **Performance Considerations**:
   - Optimize animations for performance
   - Ensure smooth scrolling and transitions
   - Test on lower-end devices

## Resources

### Official Resources

- [NeoPOP Flutter Package](https://pub.dev/packages/neopop)
- [NeoPOP GitHub Repository](https://github.com/CRED-CLUB/neopop-flutter)
- [CRED Design Website](https://design.cred.club/)

### Additional Learning

- [NeoPOP Art Movement](https://en.wikipedia.org/wiki/Neo-pop)
- [Neumorphism in UI Design](https://uxdesign.cc/neumorphism-in-user-interfaces-b47cef3bf3a6)
- [Skeuomorphism vs Flat Design vs Material Design](https://www.justinmind.com/blog/skeuomorphism-flat-design-material-design-whats-next/)

---

This guide serves as a reference for implementing CRED-inspired design principles in our project. By following these guidelines, we aim to create a beautiful, functional, and delightful experience for our users.
