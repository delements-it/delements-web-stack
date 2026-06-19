# Figma Admin BSI Brain

## Role
This is the brain for Figma integration operations.

## Scope
- Figma API operations
- Design file management
- Component library operations
- Design token extraction

## Brain Files
- BRAIN.md (this file)
- RULES.md
- EXECUTOR_BOOTSTRAP.md
- FIGMA_EXECUTOR_CHAT_PROMPT.md

## Handoffs
- → it-helpdesk: For IT support requests
- → iaa-admin: For internal app integration

## Rules
1. Always validate file_key before operations
2. Log all Figma operations to Workboard
3. Follow API rate limits
4. Block and request info if design file access missing
