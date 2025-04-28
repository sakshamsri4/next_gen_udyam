# Activity Log

## Rules and Guidelines

1. **Documentation Rules:**
   - Every action taken must be recorded in this file with a timestamp for future reference or sharing.
   - Use clear, concise language with proper formatting (bullet points, code blocks, etc.).
   - Include both what was done and why it was done to provide context.
   - Document all errors encountered and how they were resolved.
   - For significant changes, include before/after comparisons when relevant.

2. **Code Quality Rules:**
   - Follow SOLID principles in all code changes:
     - **S**ingle Responsibility: Each class should have only one reason to change.
     - **O**pen/Closed: Classes should be open for extension but closed for modification.
     - **L**iskov Substitution: Subtypes must be substitutable for their base types.
     - **I**nterface Segregation: Clients shouldn't depend on interfaces they don't use.
     - **D**ependency Inversion: Depend on abstractions, not concretions.
   - Apply DRY (Don't Repeat Yourself) principles to eliminate code duplication.
   - Follow CRED design principles for UI components:
     - **C**larity: UI elements should be clear and intuitive.
     - **R**eliability: Components should work consistently across devices and platforms.
     - **E**fficiency: UI should be optimized for performance and user flow.
     - **D**urability: Design should be resilient to content changes and future updates.

3. **Testing Rules:**
   - Follow Test-Driven Development (TDD) principles:
     - Write tests before implementing features (Red-Green-Refactor cycle).
     - Start with failing tests (Red).
     - Implement the minimum code to make tests pass (Green).
     - Refactor code while keeping tests passing (Refactor).
   - Ensure all tests are independent and don't rely on other tests.
   - Mock external dependencies to isolate the component being tested.
   - Test both happy paths and edge cases/error conditions.
   - Maintain a minimum test coverage threshold of 30%.
   - Run the full test suite locally before pushing changes.
   - Document test failures and their resolutions in this log.

4. **Git Workflow Rules:**
   - Use descriptive commit messages with prefixes (feat:, fix:, docs:, test:, refactor:, etc.).
   - Run linting and tests locally before committing.
   - Keep commits focused on a single logical change.
   - Reference issue numbers in commit messages when applicable.
   - Create separate branches for features, fixes, and refactoring.
   - Regularly pull from the main branch to avoid merge conflicts.

5. **Performance Rules:**
   - Optimize images and assets before adding them to the project.
   - Use const constructors for widgets that don't change.
   - Implement proper state management to avoid unnecessary rebuilds.
   - Profile the app regularly to identify performance bottlenecks.
   - Document performance improvements with metrics when possible.

6. **NeoPop Design Rules:**
   - Follow NeoPop design principles consistently across the app.
   - Use the neopop package (v1.0.2) for UI components.
   - Maintain consistent elevation, shadows, and depth across components.
   - Ensure proper contrast ratios for accessibility.
   - Document any custom NeoPop implementations or extensions.

## [2024-05-15]
- Initial setup of activity log file
- Project structure review
- Added NeoPop dependency to pubspec.yaml
- Set up Test-Driven Development (TDD) approach for the project

## [2024-05-16]
- Fixed Flutter binding initialization issue:
  - Added `WidgetsFlutterBinding.ensureInitialized()` to bootstrap.dart
  - Added `TestWidgetsFlutterBinding.ensureInitialized()` to test files
  - Fixed error: "Binding has not yet been initialized"
  - Ensured proper initialization before accessing platform services
  - Updated all test files to follow the same pattern

- Created documentation structure:
  - Set up docs folder for project documentation
  - Created activity_log.md to track all development activities
  - Added git_workflow.md with Git best practices
  - Added augment_rules.md for Augment Code guidelines
  - Added tdd_guidelines.md for Test-Driven Development practices
  - Established documentation standards for the project

- Implemented NeoPop UI components:
  - Added neopop: ^1.0.2 dependency to pubspec.yaml
  - Added test_coverage: ^0.6.0 and integration_test for TDD
  - Created CustomNeoPopButton widget with configurable properties:
    - Implemented proper button depth and positioning
    - Added support for shimmer effects
    - Added support for custom borders
    - Added support for parent/grandparent colors
    - Added haptic feedback for button presses
    - Added proper disabled state handling
  - Created comprehensive NeoPopExampleScreen to showcase different button styles:
    - Organized examples by categories with section titles
    - Demonstrated elevated buttons with different depths
    - Demonstrated flat buttons with different styles
    - Demonstrated bordered buttons with custom borders
    - Demonstrated shimmer effects
    - Demonstrated adjacent buttons (horizontal and vertical)
  - Implemented comprehensive tests following TDD principles:
    - Created tests for all button properties and behaviors
    - Created tests for all example screen interactions
    - Ensured 100% test coverage for new components
    - Fixed all linting issues and trailing commas

- Added Context 7 prompt requirement:
  - Updated augment_rules.md with the requirement to include "use context 7 MCP server" in prompts
  - Added dedicated section for Context 7 in augment_rules.md
  - Established requirement to always include the Context 7 phrase in prompts to Augment Code
