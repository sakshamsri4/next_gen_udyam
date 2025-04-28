# Git Workflow Guidelines

This document outlines the Git workflow and best practices for this project.

## Core Principles

1. **The main branch is sacred**: The `main` branch is for production-ready code only.
2. **Feature branches**: All development work happens in feature branches.
3. **Code review**: All changes require review before merging to `main`.
4. **Testing**: All code must pass tests before merging to `main`.
5. **Clean history**: Maintain a clean, meaningful commit history.

## Branch Naming Convention

- `feature/short-description` - For new features
- `bugfix/issue-number-description` - For bug fixes
- `hotfix/issue-number-description` - For critical production fixes
- `refactor/component-name` - For code refactoring
- `docs/topic` - For documentation updates
- `test/component-name` - For adding or updating tests
- `chore/task-description` - For build scripts, dependency updates, and maintenance tasks

## Workflow

### Starting New Work

1. Always start from an up-to-date `main` branch:
   ```bash
   git checkout main
   git pull origin main
   ```

2. Create a new branch for your work:
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. Make regular, atomic commits with clear messages:
   ```bash
   git commit -m "feat: Add new feature X"
   ```

### Commit Message Format

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- `feat:` - A new feature
- `fix:` - A bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code changes that neither fix bugs nor add features
- `test:` - Adding or updating tests
- `chore:` - Changes to the build process or auxiliary tools

### Before Pushing

1. Run all checks locally:
   ```bash
   flutter analyze
   flutter test
   ```

2. Rebase on the latest `main` if needed:
   ```bash
   git checkout main
   git pull origin main
   git checkout your-branch
   git rebase main
   ```

3. Push your branch:
   ```bash
   git push origin your-branch
   ```

### Pull Requests

1. Create a Pull Request (PR) on GitHub.
2. Ensure the PR description clearly explains the changes and purpose.
3. Link any related issues.
4. Wait for CI checks to pass.
5. Address review comments.
6. Once approved, merge using the "Squash and merge" option for a clean history.

### After Merging

1. Delete the feature branch after it's merged:
   ```bash
   git checkout main
   git pull origin main
   git branch -d your-branch
   ```

## Protected Branches

- The `main` branch is protected.
- Direct pushes to this branch are prohibited.
- PRs require at least one approval before merging.
- All CI checks must pass before merging.

## Handling Merge Conflicts

1. Rebase your branch on the latest `main`:
   ```bash
   git checkout main
   git pull origin main
   git checkout your-branch
   git rebase main
   ```

2. Resolve conflicts in each file.
3. Continue the rebase:
   ```bash
   git add .
   git rebase --continue
   ```

4. Force-push your branch (only if it's your personal feature branch):
   ```bash
   git push origin your-branch --force-with-lease
   ```

## Emergency Hotfixes

For critical production issues:

1. Create a hotfix branch from `main`:
   ```bash
   git checkout main
   git pull origin main
   git checkout -b hotfix/critical-issue
   ```

2. Make the minimal necessary changes.
3. Follow the normal PR process, but mark it as high priority.
4. After merging, ensure the fix is also applied to any in-progress feature branches.
