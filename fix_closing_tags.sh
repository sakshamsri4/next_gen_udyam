#!/usr/bin/env bash

# Fix closing markdown tags
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  sed -i '' -E 's/```markdown$/```/g' docs/third_party_integration_prompt_guide.md
else
  # Linux and others
  sed -i -E 's/```markdown$/```/g' docs/third_party_integration_prompt_guide.md
fi
