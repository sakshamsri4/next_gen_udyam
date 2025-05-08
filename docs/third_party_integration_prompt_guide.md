# Third-Party UI Integration Prompt Guide

This document provides a structured approach for working with an AI assistant to extract UI components from the third-party JobsFlutterApp and integrate them into our Next Gen Job Portal application. Follow these prompts in sequence to complete the integration efficiently.

> **Developer Note:** This guide is designed to help extract only the UI components from the third-party app while maintaining our existing Firebase backend and Supabase storage. The goal is to leverage the polished UI design without adopting the third-party business logic or API calls.

## Design Approach

When implementing UI components from the third-party app, always apply CRED design principles as documented in `docs/cred_design_guide.md`. This ensures a consistent design language throughout the application from the beginning, rather than implementing basic functionality first and then enhancing the UI later.

For each component extracted:
1. Reference the CRED design guide for appropriate styling
2. Apply CRED color system, typography, and component design principles
3. Implement animations and interactions according to CRED motion guidelines
4. Ensure responsive design while maintaining CRED design language

This approach will save time by avoiding the need to redesign components later and will result in a more cohesive user experience.

## Design Style Specifications: CRED-Inspired UI

All UI components extracted from the third-party app should be adapted to follow CRED-inspired design principles. The AI assistant should automatically apply these design principles throughout the integration process without requiring repeated requests.

### CRED Design Principles to Apply:

1. **Minimalist Luxury Aesthetic**
   - Clean, spacious layouts with generous whitespace
   - Dark mode preference with rich, deep backgrounds (#121212, #1E1E1E)
   - Subtle gradients for depth (not flat design)
   - Limited color palette with strategic accent colors

2. **Typography**
   - Sans-serif fonts (Gilroy or similar)
   - Bold, confident headlines
   - Varying font weights for visual hierarchy
   - Generous line height (1.5x) for readability

3. **Interactive Elements**
   - Subtle animations and micro-interactions
   - Haptic feedback suggestions where applicable
   - Pill-shaped buttons with slight elevation
   - Smooth transitions between states

4. **Visual Elements**
   - Rounded corners (12-16px radius)
   - Subtle shadows for depth
   - Monochromatic color schemes with occasional pops of color
   - High-contrast text against backgrounds

5. **Layout**
   - Card-based UI with layered elements
   - Bottom sheet modals instead of traditional popups
   - Asymmetrical balance in layouts
   - Prominent CTAs with clear visual hierarchy

## Phase 1: UI Components and Assets Extraction

### Step 1: Analyze UI Components
```
Please analyze the UI components in the third-party JobsFlutterApp. Focus on:
1. Custom buttons and their styles
2. Text fields and input widgets
3. Card designs and layouts
4. Avatar and image components
5. Loading animations and shimmer effects
6. Color schemes and typography
7. Icons and vector assets

For each component, identify the relevant files in the third-party app and how we can extract just the UI elements without the business logic.
```

### Step 2: Extract Core UI Components with CRED Design
```
Let's extract the core UI components from the third-party app and apply CRED design principles from our design guide. Please:
1. Create a new directory structure in our app for these components:
   - Create `lib/ui/components` directory with subdirectories for each component type
   - Set up proper exports in `lib/ui/components/index.dart`

2. Copy the button styles and widgets from:
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_button.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_save_button.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/button_with_text.dart`
   - Apply CRED button design: pill-shaped with elevation, subtle animations, and haptic feedback

3. Extract the text field designs from:
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_text_field.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/auth/views/login/widgets/login_form.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/search/views/widgets/search_bar.dart`
   - Apply CRED typography: sans-serif fonts, varying weights, generous line height

4. Copy the card layouts from:
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_job_card.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_info_card.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_tag.dart`
   - Apply CRED card design: physical appearance, elevation levels, rounded corners (12-16px)

5. Extract the avatar components from:
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_avatar.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/customerProfile/views/widgets/profile_header.dart`
   - Apply CRED styling: subtle shadows, high contrast, clean design

6. Copy the loading animations from:
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_lottie.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/shimmer/featured_job_shimmer.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/shimmer/recent_jobs_shimmer.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/shimmer/job_details_shimmer.dart`
   - Apply CRED motion principles: purpose-driven, natural physics, subtle but noticeable

7. Replace the color schemes and typography with CRED design system:
   - Instead of copying from `third_party_lib/JobsFlutterApp/lib/app/core/theme/app_theme.dart`
   - Implement CRED color system: deep backgrounds, limited palette, strategic accent colors
   - Implement CRED typography: sans-serif fonts, bold headlines, varying weights

Make sure to remove any business logic or API calls and adapt them to work with our CRED-inspired theme system. Replace any third-party dependencies with our own implementations or equivalent packages. Refer to `docs/cred_design_guide.md` for comprehensive design principles.
```

### Step 3: Create CRED-Styled Component Library
```
Now let's organize these extracted components into a reusable library following CRED design principles. Please:
1. Create a component library structure in our app
2. Organize the extracted components by type (buttons, fields, cards, etc.)
3. Ensure all components use our CRED-inspired theme system
4. Apply consistent CRED design language across all components
5. Implement animations and interactions according to CRED motion guidelines
6. Add documentation comments to each component with CRED design references
7. Create example usage for each component showing CRED styling
8. Test the components with different screen sizes while maintaining CRED design principles
9. Create a component showcase screen to demonstrate all CRED-styled components
```

## Phase 2: Home Screen Integration

### Step 4: Analyze Home Screen
```
Please analyze the home screen in the third-party app. Focus on:
1. Overall layout and structure
2. Featured jobs carousel
3. Recent jobs list
4. Category chips and filters
5. Header and search bar
6. Any animations or transitions

Identify which UI elements we should extract and how they should connect to our Firebase backend.
```

### Step 5: Extract Home Screen UI
```
Let's extract the home screen UI components. Please:
1. Copy the featured jobs carousel design from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/home/views/widgets/featured_jobs.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/home/views/widgets/body.dart`

2. Extract the recent jobs list layout from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/home/views/widgets/recent_jobs.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/home/views/widgets/section_header.dart`

3. Copy the category chips design from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/home/views/widgets/chips_list.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_chip.dart`

4. Extract the header and search bar from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/home/views/home_view.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_appbar.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/search/views/widgets/search_bar.dart`

5. Copy any relevant animations from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/home/views/widgets/featured_jobs.dart` (carousel animations)
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/shimmer/featured_job_shimmer.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/shimmer/recent_jobs_shimmer.dart`

Make sure to remove any business logic or API calls. Adapt the components to use our Firebase backend instead of the third-party API.
```

### Step 6: Implement Home Controller
```
Now let's create our own home controller that connects to Firebase. Please:
1. Create a HomeController class that uses GetX
2. Implement methods to fetch featured jobs from Firestore
3. Add functionality to get recent jobs
4. Implement category filtering
5. Connect the UI components to our controller
6. Test the home screen with our Firebase backend
```

## Phase 3: Job Details Screen Integration

### Step 7: Analyze Job Details Screen
```
Please analyze the job details screen in the third-party app. Focus on:
1. Overall layout and structure
2. Job information display
3. Company section
4. Apply button and form
5. Similar jobs section
6. Any animations or transitions

Identify which UI elements we should extract and how they should connect to our Firebase backend.
```

### Step 8: Extract Job Details UI
```
Let's extract the job details screen UI components. Please:
1. Copy the job details layout from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/JobDetails/views/job_details_view.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/JobDetails/views/widgets/body.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/JobDetails/views/widgets/details_sliver_app_bar.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/JobDetails/views/widgets/header.dart`

2. Extract the company section design from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/JobDetails/views/widgets/about_the_employer.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/companyProfile/views/widgets/company_header.dart`

3. Copy the apply button and form from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/JobDetails/views/widgets/details_bottom_nav_bar.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/JobDetails/views/widgets/apply_dialog.dart`

4. Extract the similar jobs section from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/JobDetails/views/widgets/similar_jobs.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/JobDetails/views/widgets/similar_job_card.dart`

5. Copy any relevant animations from:
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/shimmer/job_details_shimmer.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_lottie.dart` (for loading states)

Make sure to remove any business logic or API calls. Adapt the components to use our Firebase backend for job details and company information.
```

### Step 9: Implement Job Details Controller
```
Now let's create our own job details controller that connects to Firebase. Please:
1. Create a JobDetailsController class that uses GetX
2. Implement methods to fetch job details from Firestore
3. Add functionality to get company information
4. Implement job application with Firebase
5. Add similar jobs functionality
6. Connect the UI components to our controller
7. Test the job details screen with our Firebase backend
```

## Phase 4: Search Screen Integration

### Step 10: Analyze Search Screen
```
Please analyze the search screen in the third-party app. Focus on:
1. Search bar and input handling
2. Filter options and UI
3. Search results display
4. Empty and loading states
5. Any animations or transitions

Identify which UI elements we should extract and how they should connect to our Firebase backend.
```

### Step 11: Extract Search Screen UI
```
Let's extract the search screen UI components. Please:
1. Copy the search bar design from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/search/views/widgets/search_bar.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/search/views/search_view.dart`

2. Extract the filter options UI from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/search/views/widgets/filter_bottom_sheet.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/search/views/widgets/filter_chip.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/search/views/widgets/filter_section.dart`

3. Copy the search results layout from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/search/views/widgets/search_results.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/search/views/widgets/search_job_card.dart`

4. Extract the empty and loading states from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/search/views/widgets/empty_search.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/shimmer/search_results_shimmer.dart`

5. Copy any relevant animations from:
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_lottie.dart` (for empty states)
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/shimmer/search_results_shimmer.dart`

Make sure to remove any business logic or API calls. Adapt the components to use our Firebase backend for search functionality.
```

### Step 12: Implement Search Controller
```
Now let's create our own search controller that connects to Firebase. Please:
1. Create a SearchController class that uses GetX
2. Implement methods to search jobs in Firestore
3. Add filtering functionality
4. Implement loading and empty states
5. Connect the UI components to our controller
6. Test the search screen with our Firebase backend
```

## Phase 5: Profile Screens Integration

### Step 13: Analyze Profile Screens
```
Please analyze the profile screens in the third-party app. Focus on:
1. Customer profile layout and sections
2. Company profile layout and sections
3. Profile editing forms
4. Image upload UI
5. Any animations or transitions

Identify which UI elements we should extract and how they should connect to our Firebase backend and Supabase storage.
```

### Step 14: Extract Profile Screens UI
```
Let's extract the profile screens UI components. Please:
1. Copy the customer profile layout from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/customerProfile/views/customer_profile_view.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/customerProfile/views/widgets/profile_header.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/customerProfile/views/widgets/profile_body.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/customerProfile/views/widgets/profile_info_card.dart`

2. Extract the company profile layout from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/companyProfile/views/company_profile_view.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/companyProfile/views/widgets/company_header.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/companyProfile/views/widgets/company_info.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/companyProfile/views/widgets/jobs_list.dart`

3. Copy the profile editing forms from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/customerProfile/views/widgets/edit_profile_dialog.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/companyProfile/views/widgets/edit_company_dialog.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_text_field.dart`

4. Extract the image upload UI from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/customerProfile/views/widgets/profile_image_picker.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/companyProfile/views/widgets/company_logo_picker.dart`

5. Copy any relevant animations from:
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/shimmer/profile_shimmer.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_lottie.dart` (for loading states)

Make sure to remove any business logic or API calls. Adapt the components to use our Firebase backend for profile data and Supabase storage for image uploads.
```

### Step 15: Implement Profile Controllers
```
Now let's create our own profile controllers that connect to Firebase and Supabase. Please:
1. Create CustomerProfileController and CompanyProfileController classes that use GetX
2. Implement methods to fetch profile data from Firestore
3. Add profile updating functionality
4. Implement image upload with Supabase storage
5. Connect the UI components to our controllers
6. Test the profile screens with our Firebase backend and Supabase storage
```

## Phase 6: Saved Jobs Screen Integration

### Step 16: Analyze Saved Jobs Screen
```
Please analyze the saved jobs screen in the third-party app. Focus on:
1. Overall layout and structure
2. Saved job cards design
3. Empty state design
4. Save/unsave toggle functionality
5. Any animations or transitions

Identify which UI elements we should extract and how they should connect to our Firebase backend.
```

### Step 17: Extract Saved Jobs Screen UI
```
Let's extract the saved jobs screen UI components. Please:
1. Copy the saved jobs layout from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/saved/views/saved_view.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/saved/views/widgets/body.dart`

2. Extract the saved job cards design from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/saved/views/widgets/saved_job_card.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_job_card.dart` (with saved state)

3. Copy the empty state design from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/saved/views/widgets/empty_saved.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_lottie.dart` (for empty states)

4. Extract the save/unsave toggle UI from:
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_save_button.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/JobDetails/views/widgets/details_sliver_app_bar.dart` (save button implementation)

5. Copy any relevant animations from:
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/shimmer/saved_jobs_shimmer.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_lottie.dart` (for loading and empty states)

Make sure to remove any business logic or API calls. Adapt the components to use our Firebase backend for saved jobs functionality.
```

### Step 18: Implement Saved Jobs Controller
```
Now let's create our own saved jobs controller that connects to Firebase. Please:
1. Create a SavedJobsController class that uses GetX
2. Implement methods to fetch saved jobs from Firestore
3. Add save/unsave toggle functionality
4. Implement empty state handling
5. Connect the UI components to our controller
6. Test the saved jobs screen with our Firebase backend
```

## Phase 7: Navigation Integration

### Step 19: Analyze Navigation Elements
```
Please analyze the navigation elements in the third-party app. Focus on:
1. Bottom navigation bar design
2. Drawer menu layout
3. Tab navigation components
4. Navigation animations
5. Route management

Identify which UI elements we should extract and how they should connect to our existing navigation system.
```

### Step 20: Extract Navigation UI
```
Let's extract the navigation UI components. Please:
1. Copy the bottom navigation bar design from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/root/views/root_view.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/modules/root/views/widgets/bottom_nav_bar.dart` (if exists)

2. Extract the drawer menu layout from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/root/views/widgets/menu_view.dart`
   - `third_party_lib/JobsFlutterApp/lib/app/widgets/custom_drawer.dart` (if exists)

3. Copy the tab navigation components from:
   - `third_party_lib/JobsFlutterApp/lib/app/modules/search/views/widgets/filter_section.dart` (tab-like filter)
   - Any other tab navigation components found in the app

4. Extract any navigation animations from:
   - `third_party_lib/JobsFlutterApp/lib/app/routes/app_pages.dart` (transition definitions)
   - `third_party_lib/JobsFlutterApp/lib/main.dart` (default transition)

Make sure to remove any business logic or route management code. Adapt the components to work with our existing navigation system.
```

### Step 21: Implement Navigation System
```
Now let's create our own navigation system that connects to our routes. Please:
1. Create or update our navigation controller
2. Implement bottom navigation with our routes
3. Add drawer menu functionality
4. Implement tab navigation where needed
5. Connect the UI components to our navigation system
6. Test the navigation flow with all our screens
```

## Phase 8: Final Integration and Testing

### Step 22: Final Integration
```
Let's finalize the integration of all UI components. Please:
1. Ensure all screens are properly connected
2. Verify that all Firebase and Supabase connections work
3. Check that all UI components use our theme system
4. Remove any remaining third-party code or references
5. Clean up any unused files or code
```

### Step 23: Comprehensive Testing
```
Let's test the integrated app thoroughly. Please:
1. Test all screens with different data scenarios
2. Verify all functionality works with our Firebase backend
3. Test file uploads with Supabase storage
4. Check responsive design on different screen sizes
5. Test edge cases like empty data, loading states, and errors
6. Verify that no third-party code or files remain
```

### Step 24: Documentation Update
```
Finally, let's update our documentation. Please:
1. Update the project roadmap to reflect the completed integration
2. Document which UI components were extracted from the third-party app
3. Create usage examples for our component library
4. Update the activity log with integration milestones
5. Create any necessary developer documentation
```
