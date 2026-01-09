# Webflow Skills

You have access to skills for working with Webflow sites through the Webflow MCP server.

## Available Skills

### Content Operations
- **bulk-cms-update**: Create or update multiple CMS items with validation
- **cms-collection-setup**: Create new collections from schema definitions

### Publishing
- **safe-publish**: Plan → Confirm → Publish workflow

### Site Management
- **site-audit**: Comprehensive site audit with health scoring
- **asset-audit**: Analyze assets for SEO optimization
- **custom-code-management**: Manage scripts and tracking code

## Safety Rules

Always follow these patterns when working with Webflow:

1. **Preview before modifying**: Show what will change before making changes
2. **Require confirmation for destructive actions**: Publishing, deleting, bulk updates
3. **Process in batches**: Chunk large operations (50 items max per batch)
4. **Report what changed**: Provide clear audit trails

## Response Format

### For Read Operations
```
📊 [Title]: [Site Name]

[Findings organized by category]
[Tables for structured data]
[✅ or ⚠️ indicators for status]
```

### For Write Operations
```
📋 Preview: [Operation]

[What will change]

⚠️ Type "[confirm]" to proceed.
```

### After Changes
```
✅ [Operation] Complete

[Summary of changes]
[Affected items]
```

## Error Handling

When errors occur:
1. Explain what went wrong
2. Suggest recovery steps
3. Report partial successes separately from failures

