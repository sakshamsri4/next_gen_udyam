# The Pragmatic Programmer Checklist

This document provides a checklist of principles and practices from "The Pragmatic Programmer" by Andrew Hunt and David Thomas, adapted specifically for our Flutter/Dart project. Use this as a reference to ensure we're following best practices in our development process.

## Core Pragmatic Principles

### 🧠 Mindset & Philosophy

- [ ] **Take responsibility**: "It's not my fault" doesn't fix bugs. Own problems and their solutions.
- [ ] **Don't live with broken windows**: Fix "broken windows" (bad designs, wrong decisions, poor code) as soon as they're discovered.
- [ ] **Be a catalyst for change**: Don't wait for permission to improve things.
- [ ] **Make quality a requirements issue**: Set explicit quality requirements and stick to them.
- [ ] **Invest regularly in your knowledge portfolio**: Read technical books, try new languages/frameworks, and stay curious.
- [ ] **Think critically**: Analyze and critique approaches rather than blindly following trends.
- [ ] **Care about your craft**: Take pride in your work.

### 💻 Coding Wisdom

- [ ] **DRY principle**: Don't Repeat Yourself - avoid duplication of code, knowledge, and intent.
- [ ] **Orthogonality**: Design components that are independent and have a single, well-defined purpose.
- [ ] **Reversibility**: Design for change by avoiding irreversible decisions.
- [ ] **Tracer bullets**: Implement end-to-end functionality early to prove your architecture works.
- [ ] **Prototypes**: Use throwaway code to explore and learn.
- [ ] **Domain languages**: Codify domain knowledge in models and abstractions.
- [ ] **Estimate to avoid surprises**: Break tasks into smaller components to estimate more accurately.
- [ ] **Keep knowledge in plain text**: Prefer plain text for documentation, configuration, etc., for easier version control and automation.

### 🔧 Practical Techniques

- [ ] **Fix the root problem**: Treat root causes, not symptoms.
- [ ] **Select isn't broken**: Don't blame the system; check your own code first.
- [ ] **Learn a text editor**: Master your primary code editing tool.
- [ ] **Use version control**: Always use version control, even for experiments and documentation.
- [ ] **Fix it now**: Fix issues when they're discovered, or add to a tracked list.
- [ ] **Test your software**: Write tests for your code, including edge cases.
- [ ] **Refactor early and often**: Continuously improve code to prevent entropy.
- [ ] **Design to test**: Design components to be easily testable.

## Flutter & Dart Specific Guidelines

### 🎯 Dart Best Practices

- [ ] **Effective Dart**: Follow the official [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines.
- [ ] **Null safety**: Embrace null safety features to catch null errors at compile time.
- [ ] **Strong typing**: Use specific types instead of `dynamic` when possible.
- [ ] **Named parameters**: Use named parameters for better readability, especially when many parameters are involved.
- [ ] **Code documentation**: Document public APIs with dartdoc comments.
- [ ] **Prefer final variables**: Use `final` or `const` when variables don't change.
- [ ] **Use linting**: Set up and follow a comprehensive lint rule set.
- [ ] **Consistent formatting**: Use `dart format` to maintain consistent code style.
- [ ] **Avoid large functions**: Break large functions into smaller, focused ones.
- [ ] **Extension methods**: Use extension methods to add functionality to existing classes.

### 🐦 Flutter Architecture

- [ ] **State management**: Choose appropriate state management solutions for different needs (GetX, Provider, Riverpod, Bloc).
- [ ] **Separation of concerns**: Clearly separate UI, business logic, and data layers.
- [ ] **Composition over inheritance**: Prefer composing widgets over extending them.
- [ ] **Code generation**: Use code generation tools for repetitive tasks (JSON serialization, routing).
- [ ] **Responsive design**: Design UIs that work across different screen sizes.
- [ ] **Platform adaptiveness**: Use platform-specific widgets when appropriate.
- [ ] **Lazy loading**: Implement lazy loading for expensive operations and large datasets.
- [ ] **Widget keys**: Use keys appropriately to maintain widget state.
- [ ] **Localization**: Plan for internationalization from the beginning.
- [ ] **Error boundaries**: Implement error handling at appropriate levels.

### 🚀 Flutter Performance

- [ ] **Build context**: Avoid passing BuildContext to asynchronous operations that may complete after the widget is disposed.
- [ ] **Const constructors**: Use `const` for widget constructors when possible.
- [ ] **List view optimization**: Use `ListView.builder` for long lists.
- [ ] **Image optimization**: Optimize and cache images.
- [ ] **Animations**: Prefer implicit animations or the Flutter animation framework.
- [ ] **State preservation**: Implement state preservation and restoration.
- [ ] **Avoid rebuilds**: Minimize unnecessary widget rebuilds.
- [ ] **Lazy widgets**: Implement lazy widget initialization and loading.
- [ ] **Memory leaks**: Watch for and prevent memory leaks, especially with streams and listeners.
- [ ] **Offload to isolates**: Move expensive computations to background isolates.

## Project-Specific Guidelines

### 🧪 Test-Driven Development

- [ ] **Follow the Red-Green-Refactor cycle**: Write failing tests first, implement the minimum code to pass, then refactor.
- [ ] **Test at appropriate levels**: Write unit tests for logic, widget tests for UI, integration tests for user flows.
- [ ] **Mock dependencies**: Use mockito/mocktail to isolate the unit under test.
- [ ] **Test edge cases**: Include tests for error conditions and boundary values.
- [ ] **Test naming**: Use descriptive test names that explain the expected behavior.
- [ ] **Arrange-Act-Assert pattern**: Structure tests clearly with setup, action, and verification.
- [ ] **Test fixtures**: Create reusable test data and helpers.
- [ ] **Keep tests fast**: Optimize tests to run quickly for rapid feedback.
- [ ] **Continuous testing**: Run tests automatically on changes.
- [ ] **Maintain test coverage**: Ensure a minimum of 30% test coverage, aiming for 90% in core modules.

### 🎨 CRED-inspired Design

- [ ] **Follow NeoPOP principles**: Implement UI according to NeoPOP style guidelines.
- [ ] **Consistent elevation**: Apply proper depth and shadows based on component importance.
- [ ] **Physical feedback**: Implement subtle haptic feedback for interactions.
- [ ] **Color consistency**: Use the defined color system consistently.
- [ ] **Typography hierarchy**: Follow the established typography scale and weights.
- [ ] **Animation principles**: Ensure animations have purpose, follow natural physics, and are consistent.
- [ ] **Accessibility**: Test designs for color contrast, touch target size, and screen reader compatibility.
- [ ] **Component consistency**: Maintain consistent styling across similar components.
- [ ] **Responsive design**: Ensure designs adapt gracefully to different screen sizes.

### 📋 Code Review Checklist

- [ ] **Readability**: Code is easy to understand without comments.
- [ ] **Maintainability**: Changes don't increase technical debt.
- [ ] **Documentation**: Code includes necessary documentation.
- [ ] **Tests**: Changes include appropriate tests.
- [ ] **Performance**: Code doesn't introduce performance regressions.
- [ ] **Security**: Code doesn't introduce security vulnerabilities.
- [ ] **Error handling**: Errors are properly caught and handled.
- [ ] **Accessibility**: UI changes maintain or improve accessibility.
- [ ] **Conventions**: Code follows project conventions and style guide.

## Automation and Tools

- [ ] **Automate daily tasks**: Use scripts and tools for repetitive tasks.
- [ ] **CI/CD pipeline**: Maintain a robust CI/CD pipeline that ensures quality.
- [ ] **Static analysis**: Use static analysis tools to catch issues early.
- [ ] **Code generators**: Use code generators for repetitive code patterns.
- [ ] **Refactoring tools**: Leverage IDE refactoring tools for safer changes.
- [ ] **Dependency management**: Regularly review and update dependencies.
- [ ] **Performance monitoring**: Implement tools to monitor app performance.
- [ ] **Error tracking**: Use error tracking services in production.

## Team Communication

- [ ] **No broken windows**: Don't tolerate broken processes or poor communication.
- [ ] **Team entropy**: Fight against disorder in team processes.
- [ ] **Ubiquitous language**: Use consistent terminology across code, documentation, and discussions.
- [ ] **Written communication**: Prefer written, asynchronous communication for important decisions.
- [ ] **Knowledge sharing**: Regularly share learnings and discoveries with the team.
- [ ] **Activity logging**: Maintain detailed activity logs for knowledge transfer.
- [ ] **Pragmatic learning**: Learn from mistakes and share lessons.

## Regular Reflection

- [ ] **Project retrospectives**: Schedule regular project retrospectives.
- [ ] **Personal improvement**: Identify areas for personal improvement.
- [ ] **Process refinement**: Continuously refine development processes.
- [ ] **Technical debt management**: Regularly address technical debt.
- [ ] **Knowledge exchange**: Create opportunities for knowledge exchange.
- [ ] **Celebrate successes**: Recognize and celebrate team achievements.

---

This checklist is a living document. Add, modify, or remove items as our project evolves and we discover what works best for our team.

Remember, as The Pragmatic Programmer teaches us: "The greatest of all weaknesses is the fear of appearing weak." Be willing to ask questions, admit when you don't know something, and continuously learn and improve.