# Scripts

This directory contains utility scripts for development workflow.

## Git Hooks

### pre-commit.sh

A Git pre-commit hook that automatically formats Dart files before committing.

**Features:**
- Automatically formats staged Dart files with a line length of 80 characters
- Re-stages the formatted files
- Only processes Dart files that are staged for commit

**Installation:**
```bash
make setup
```

### pre-push.sh

A Git pre-push hook that runs various checks before pushing.

**Features:**
- Prevents direct pushes to the main branch
- Checks if the activity log has been updated
- Runs Flutter format check
- Runs Flutter analyze
- Runs Flutter tests
- Runs spell check (if cspell is installed)

**Installation:**
```bash
make setup
```

## Utility Scripts

### format_all.sh

A script to format all Dart files in the project.

**Features:**
- Formats all Dart files in the lib and test directories
- Uses a line length of 80 characters

**Usage:**
```bash
./scripts/format_all.sh
# or
make format-all
```

### extract_technical_terms.sh

A script to extract potential technical terms from the codebase for spell checking.

**Features:**
- Extracts camelCase and PascalCase identifiers from Dart files
- Extracts words with underscores from Dart files
- Extracts package names from pubspec.yaml
- Outputs a sorted list of potential technical terms

**Usage:**
```bash
./scripts/extract_technical_terms.sh
# or
make extract-terms
```

## Troubleshooting

### Permission Issues

If you encounter permission issues when running the scripts, make them executable:

```bash
chmod +x scripts/*.sh
```

### cspell Not Found

If the pre-push hook reports that cspell is not found, you can install it with:

```bash
npm install -g cspell
```

Or you can continue without spell checking by answering 'y' when prompted.
