#!/usr/bin/env bash

# Find all code blocks in the markdown file and add language specifier
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  ```$/```markdown/g' docs/third_party_integration_prompt_guide.md
else
  # Linux and others
  sed -i -E 's/^```$/```markdown/g' docs/third_party_integration_prompt_guide.md
fi
