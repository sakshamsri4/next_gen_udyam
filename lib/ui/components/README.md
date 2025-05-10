# UI Components Library

This library contains UI components extracted from the third-party JobsFlutterApp and adapted to work with our existing theme system. The components are organized by type and can be used throughout the app.

## Directory Structure

```
lib/ui/components/
├── avatars/
│   └── custom_avatar.dart
├── buttons/
│   ├── button_with_text.dart
│   ├── custom_button.dart
│   └── custom_save_button.dart
├── cards/
│   ├── custom_info_card.dart
│   ├── custom_job_card.dart
│   └── custom_tag.dart
├── fields/
│   ├── custom_text_field.dart
│   └── search_bar.dart
├── loaders/
│   ├── custom_lottie.dart
│   └── shimmer/
│       ├── featured_job_shimmer.dart
│       ├── job_details_shimmer.dart
│       ├── recent_jobs_shimmer.dart
│       └── shimmer_widget.dart
├── theme/
│   └── theme_extensions.dart
├── example_usage.dart
├── index.dart
└── README.md
```

## Usage

Import the components you need from the library:

```dart
import 'package:next_gen/ui/components/buttons/custom_button.dart';
import 'package:next_gen/ui/components/cards/custom_job_card.dart';
// ... or import everything
import 'package:next_gen/ui/components/index.dart';
```

## Components

### Buttons

- `CustomButton`: A button with loading state
- `CustomSaveButton`: A save/bookmark button with loading and toggled states
- `ButtonWithText`: A button with text below it, commonly used for login/signup screens

### Fields

- `CustomTextField`: A text field with various configurations (regular, password, phone, search)
- `SearchBar`: A specialized text field for search functionality

### Cards

- `CustomJobCard`: A card for displaying job information
- `CustomInfoCard`: A card for displaying information with a title and icon
- `CustomTag`: A tag for displaying job attributes (workplace, employment type, location)

### Avatars

- `CustomAvatar`: An avatar component for displaying profile images

### Loaders

- `CustomLottie`: A component for displaying Lottie animations with text
- `ShimmerWidget`: A base widget for creating shimmer effects
- `FeaturedJobShimmer`: A shimmer effect for featured job cards
- `RecentJobsShimmer`: A shimmer effect for recent job cards
- `JobDetailsShimmer`: A shimmer effect for the job details screen

### Theme

- `theme_extensions.dart`: Extensions for ThemeData, ColorScheme, and TextTheme to ensure consistent theme access

## Example

See `example_usage.dart` for examples of how to use each component.

## Adapting to Our Theme

All components use the theme from the context, so they will automatically adapt to our theme system. The components use:

- `theme.colorScheme.primary` for primary colors
- `theme.colorScheme.secondary` for secondary colors
- `theme.colorScheme.surface` for background colors
- `theme.colorScheme.onSurface` for text colors
- `theme.colorScheme.error` for error colors

## Dependencies

These components depend on the following packages:

- `flutter_screenutil` for responsive sizing
- `get` for GetX utilities
- `google_fonts` for typography
- `heroicons` for icons
- `cached_network_image` for image caching
- `shimmer` for shimmer effects
- `lottie` for Lottie animations
- `intl` for date formatting
- `intl_phone_field` for phone number input

Make sure these dependencies are added to your `pubspec.yaml` file.
