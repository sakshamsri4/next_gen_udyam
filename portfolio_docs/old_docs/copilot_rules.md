# GitHub Copilot Rules

## General Guidelines
1. Always prioritize Flutter and Dart best practices when suggesting code modifications.
2. Remember that this is a portfolio website built with Flutter Web.
3. Follow the existing project architecture and patterns.
4. Maintain code consistency with the existing codebase.
5. Assume responsive design is important for all UI elements.
6. **ALWAYS update the activity log at docs/activity/activity_log.md after completing any task.**
7. **Always read the activity log before starting work to understand previous approaches.**
8. **Never consider a task complete until the activity log has been updated.**

## Activity Log Requirements
1. Every completed task must be documented in the activity log with:
   - Date in [YYYY-MM-DD] format at the top of your entry
   - Clear description of what you were trying to accomplish
   - Step-by-step approach used to solve the problem
   - Any issues encountered and how they were resolved
   - Failed approaches that were tried, to avoid repeating mistakes
   - Successful solutions with explanations of why they worked
   - Code snippets for key implementations (when appropriate)
   - References to documentation or resources that were helpful
   - Lessons learned that could be applied to future tasks

2. Format activity log entries with proper Markdown:
   - Use headers for main sections
   - Use bullet points for lists of steps or issues
   - Use code blocks for code snippets
   - Use bold text for important notes or warnings
   - Use distinct sections for problems, approaches, and solutions

3. Always reference previous activity log entries when a similar issue was encountered before.

## Mandatory Post-Task Checklist
Before considering ANY task complete, verify that you have:

1. ✅ Updated the activity log with a comprehensive entry following the template
2. ✅ Added the date in [YYYY-MM-DD] format
3. ✅ Included all attempted approaches (both successful and failed)
4. ✅ Documented the root cause of any issues
5. ✅ Added relevant code snippets or file changes
6. ✅ Listed lessons learned and insights for future reference
7. ✅ Checked for spelling and formatting errors in the log entry
8. ✅ Verified the activity log successfully updated by confirming the edit

**IMPORTANT: NEVER skip this checklist for any task, no matter how small.**

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
1. Suggest test coverage for new functionality.
2. Follow the project's naming conventions and style guidelines.
3. Identify potential performance issues, especially those specific to Flutter Web.
4. Consider accessibility in all UI suggestions.
5. Recommend proper error handling where applicable.

## Documentation
<!-- cspell:ignore dartdoc -->
1. Include dartdoc comments for public APIs.
2. Explain complex algorithms or business logic with inline comments.
3. Document any workarounds or non-standard approaches.

## Dependencies
1. Prefer existing dependencies before suggesting new ones.
2. When suggesting new packages, prioritize those with:
   - High pub.dev scores
   - Recent updates
   - Good Flutter Web compatibility
   - Null safety support

## Architecture
1. Maintain separation of concerns (UI, business logic, data).
2. Follow the project's state management approach.
3. Respect the existing folder structure.
4. Keep widgets modular and reusable where possible.

## Flutter Web Specific
1. Be mindful of Flutter Web rendering issues and limitations.
2. Consider browser compatibility for any web-specific features.
3. Optimize assets and resources for web delivery.
4. Be aware of differences between mobile and web implementations.

## Performance
1. Suggest const constructors where appropriate.
2. Identify potential memory leaks.
3. Avoid unnecessary rebuilds in the widget tree.
4. Consider widget memoization techniques when appropriate.

## Testing
1. Follow the project's existing testing patterns.
2. Use appropriate mocking techniques as shown in the test directory.
3. Ensure tests are meaningful and cover edge cases.

## Enforcement Mechanisms
1. **Beginning of Session Check**: At the start of any assistance session, acknowledge that you've read and will follow these rules.
2. **Pre-Implementation Planning**: Before implementing any solution, explicitly outline how it adheres to these guidelines.
3. **Post-Implementation Verification**: After completing a task, verify that the solution follows all relevant rules and document this in the activity log.
4. **Issue Template**: When facing a problem, use this template to document it:
   ```markdown
   ## Issue Description
   [Clear description of the issue]

   ## Attempted Solutions
   1. [First approach tried]
   2. [Second approach tried]

   ## Root Cause
   [Analysis of why the issue occurred]

   ## Working Solution
   [The approach that solved the problem]

   ## Prevention Strategy
   [How to avoid this issue in the future]
   ```
5. **Reference Previous Solutions**: Always check if a similar issue has been documented before and reference the previous solution.
6. **Rules Reminder Command**: If I type "reminder:rules", immediately respond with a summary of these rules and confirm you will follow them.
7. **Activity Log Verification**: After every edit or solution, explicitly state "I have updated the activity log with this change" and provide a brief summary of what was documented.
8. **Post-Task Completion Check**: After every task, use this checklist to verify all requirements were met:
   - [ ] Code changes implemented correctly
   - [ ] Tests passing (if applicable)
   - [ ] Activity log updated with comprehensive entry
   - [ ] All attempted approaches documented
   - [ ] Root cause analysis included
   - [ ] Working solution described with code snippets
   - [ ] Lessons learned documented

9. **Update Verification Protocol**: After updating the activity log, always:
   - Confirm the file was edited successfully
   - Quote a brief portion of the added content to verify
   - Explicitly state "Activity log update complete and verified"