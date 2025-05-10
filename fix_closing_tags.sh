#!/bin/bash

# Fix closing markdown tags
sed -i '' -E 's/```markdown$/```/g' docs/third_party_integration_prompt_guide.md
