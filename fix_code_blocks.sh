#!/bin/bash

# Find all code blocks in the markdown file and add language specifier
sed -i '' -E 's/^```$/```markdown/g' docs/third_party_integration_prompt_guide.md
