# Augment Code Rules

This document outlines the guidelines for using Augment Code in this project to ensure consistent, high-quality results.

## General Guidelines

1. Always prioritize Flutter and Dart best practices when requesting code modifications.
2. Follow the existing project architecture and patterns.
3. Maintain code consistency with the existing codebase.
4. Assume responsive design is important for all UI elements.
6. **ALWAYS update the activity log at docs/activity_log.md after completing any task.**
7. **Always read the activity log before starting work to understand previous approaches.**
8. **Never consider a task complete until the activity log has been updated.**

## Effective Prompting

1. Be specific and detailed in your requests:
   - Specify the exact file(s) to be modified
   - Describe the desired outcome clearly
   - Provide context about why the change is needed
   - Mention any constraints or requirements

2. Break down complex tasks into smaller, manageable steps:
   - Request one logical change at a time
   - Build upon previous changes incrementally
   - Verify each step works before moving to the next

3. Use clear formatting in your prompts:
   - Use bullet points for lists of requirements
   - Use code blocks for code examples
   - Use bold text for important notes or warnings
   - Structure your request logically (context → task → expected outcome)

## Error Reduction Strategies

1. **Preliminary Research**:
   - Always ask Augment to research the codebase before making changes
   - Request information about related files and dependencies
   - Ask for a plan before implementing changes

2. **Incremental Changes**:
   - Make small, focused changes rather than large rewrites
   - Verify each change works before proceeding
   - Keep track of what has been modified

3. **Explicit Instructions**:
   - Specify file paths exactly
   - Provide context about the surrounding code
   - Mention any patterns or conventions to follow
   - Be explicit about imports and dependencies

4. **Verification Steps**:
   - Ask Augment to explain its changes
   - Request tests for new functionality
   - Have Augment verify its own work by running tests or checks

5. **Documentation**:
   - Request documentation for complex changes
   - Ask for comments in the code
   - Have Augment update the activity log with details

## Activity Log Entry Template

Use this template for all activity log entries:

```markdown
## [YYYY-MM-DD]
- Task: [Brief description of what you were trying to accomplish]
  - **Issue Description**:
    - [Clear explanation of the problem or task]

  - **Root Cause Analysis** (if applicable):
    - [Analysis of why the issue occurred]

  - **Attempted Solutions**:
    1. [First approach tried]
    2. [Second approach tried]

  - **Working Solution**:
    - [The approach that solved the problem]
    - [Code snippets or file changes made]

  - **Lessons Learned**:
    - [Key insights gained from this task]
    - [How to avoid similar issues in the future]
    - [Best practices to follow]
```

## Code Quality

1. Request test coverage for new functionality.
2. Follow the project's naming conventions and style guidelines.
3. Ask Augment to identify potential performance issues.
4. Consider accessibility in all UI suggestions.
5. Request proper error handling where applicable.

## Documentation

1. Ask for dartdoc comments for public APIs.
2. Request explanations for complex algorithms or business logic.
3. Have Augment document any workarounds or non-standard approaches.

## Dependencies

1. Prefer existing dependencies before requesting new ones.
2. When considering new packages, prioritize those with:
   - High pub.dev scores
   - Recent updates
   - Good Flutter compatibility
   - Null safety support

## Architecture

1. Maintain separation of concerns (UI, business logic, data).
2. Follow the project's state management approach.
3. Respect the existing folder structure.
4. Keep widgets modular and reusable where possible.

## Testing

1. Always request tests for new functionality.
2. Follow Test-Driven Development (TDD) principles.
3. Ask for both unit tests and widget tests where appropriate.
4. Ensure tests cover edge cases and error conditions.

## NeoPop Design

1. Request consistent use of NeoPop design elements.
2. Ask for proper implementation of NeoPop widgets from the neopop package.
3. Ensure accessibility is maintained with NeoPop components.
4. Request documentation for custom NeoPop implementations.
