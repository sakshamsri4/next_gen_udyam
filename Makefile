# Makefile for Next Gen Udyam project

.PHONY: setup install-tools format format-all analyze test coverage lint fix-lint clean check pre-push feature bugfix hotfix docs spell-check extract-terms generate-icons outdated unused

# Setup the project and git hooks
setup:
	@echo "Setting up the project..."
	@mkdir -p .git/hooks
	@chmod +x scripts/*.sh
	@ln -sf ../../scripts/pre-commit.sh .git/hooks/pre-commit
	@ln -sf ../../scripts/pre-push.sh .git/hooks/pre-push
	@flutter pub get
	@./scripts/format_all.sh
	@echo "Setup complete!"
	@echo "NOTE: For full functionality, run 'make install-tools' to install required external tools."

# Install required external tools
install-tools:
	@echo "Installing required external tools..."
	@if command -v npm > /dev/null; then \
		echo "Installing cspell..."; \
		npm install -g cspell; \
	else \
		echo "npm not found. Please install Node.js and npm first."; \
		exit 1; \
	fi
	@if command -v brew > /dev/null; then \
		echo "Installing lcov using Homebrew..."; \
		brew install lcov; \
	elif command -v apt-get > /dev/null; then \
		echo "Installing lcov using apt-get..."; \
		sudo apt-get install -y lcov; \
	else \
		echo "Could not install lcov automatically. Please install it manually."; \
	fi
	@echo "Tools installation complete!"

# Format code using dart format
format:
	@echo "Formatting code..."
	@dart format --line-length=80 .

# Format all Dart files using the format_all.sh script
format-all:
	@./scripts/format_all.sh

# Run Flutter analyzer
analyze:
	@echo "Running Flutter analyzer..."
	@flutter analyze

# Run tests
test:
	@echo "Running tests..."
	@flutter test

# Run tests with coverage
coverage:
	@echo "Running tests with coverage..."
	@flutter test --coverage
	@if command -v genhtml >/dev/null 2>&1; then \
		echo "Generating coverage report..."; \
		genhtml coverage/lcov.info -o coverage/html; \
		echo "Coverage report generated at coverage/html/index.html"; \
	else \
		echo "genhtml not found. Install lcov to generate HTML reports."; \
	fi

# Run linter checks
lint:
	@echo "Running linter checks..."
	@flutter analyze

# Fix linter issues automatically
fix-lint:
	@echo "Fixing linter issues..."
	@dart fix --apply

# Clean the project
clean:
	@echo "Cleaning the project..."
	@flutter clean
	@rm -rf coverage

# Run all checks (format, analyze, test, spell-check)
check: format analyze test spell-check
	@echo "All checks passed!"

# Run pre-push checks
pre-push:
	@./scripts/pre-push.sh

# Create a feature branch
feature:
	@read -p "Enter feature name (e.g., add-login): " name; \
	git checkout main && \
	git pull origin main && \
	git checkout -b feature/$$name && \
	echo "Created and switched to branch feature/$$name"

# Create a bugfix branch
bugfix:
	@read -p "Enter issue number: " issue; \
	read -p "Enter brief description: " desc; \
	git checkout main && \
	git pull origin main && \
	git checkout -b bugfix/$$issue-$$desc && \
	echo "Created and switched to branch bugfix/$$issue-$$desc"

# Create a hotfix branch
hotfix:
	@read -p "Enter issue number: " issue; \
	read -p "Enter brief description: " desc; \
	git checkout main && \
	git pull origin main && \
	git checkout -b hotfix/$$issue-$$desc && \
	echo "Created and switched to branch hotfix/$$issue-$$desc"

# Create a docs branch
docs:
	@read -p "Enter documentation topic: " topic; \
	git checkout main && \
	git pull origin main && \
	git checkout -b docs/$$topic && \
	echo "Created and switched to branch docs/$$topic"

# Run spell check
spell-check:
	@if command -v cspell > /dev/null; then \
		echo "Running spell check..."; \
		cspell "**/*.{dart,md,yaml,json}" --no-progress; \
	else \
		echo "cspell not found. Please install it with 'npm install -g cspell'"; \
		exit 1; \
	fi

# Extract technical terms for spell checking
extract-terms:
	@./scripts/extract_technical_terms.sh

# Generate app icons for all platforms
generate-icons:
	@chmod +x scripts/generate_app_icons.sh
	@./scripts/generate_app_icons.sh

# Check for outdated dependencies
outdated:
	@echo "Checking for outdated dependencies..."
	@flutter pub outdated

# Check for unused dependencies
unused:
	@echo "Checking for unused dependencies..."
	@if command -v flutter_package_analyzer > /dev/null; then \
		flutter_package_analyzer; \
	else \
		echo "flutter_package_analyzer not found. Install with 'dart pub global activate flutter_package_analyzer'"; \
		exit 1; \
	fi
