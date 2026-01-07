---
name: bulk-cms-update
description: Create or update multiple CMS items in a Webflow collection with validation and diff preview. Use when adding multiple blog posts, products, or updating fields across many items.
---

# Bulk CMS Update

Create or update multiple CMS items with validation and preview before applying changes.

## Instructions

1. **Identify the target**: Get site name and collection name from the user
2. **Validate the data**: Check that collection exists and field names match the schema
3. **Generate preview**: Show a diff of what will be created or changed
4. **Wait for confirmation**: Require explicit approval before making changes
5. **Execute in batches**: Process items in groups of 50 to avoid rate limits
6. **Report results**: Show what was created/updated with IDs

## Examples

**User prompt:**
```
Add these 5 blog posts to my "Articles" collection:
1. "Getting Started" - author: Sarah
2. "Best Practices" - author: Mike
```

**Response format:**
```
📋 Preview: Create 5 Blog Posts

Collection: Articles
Items to create: 5

1. "Getting Started"
   └── author: → Sarah

2. "Best Practices"
   └── author: → Mike

⚠️ Type "create" to proceed.
```

**After confirmation:**
```
✅ Created 5 items

- "Getting Started" (id: 64f1...)
- "Best Practices" (id: 64f2...)
```

## Guidelines

- Always show preview before creating/updating
- Validate field names against collection schema
- Validate reference fields point to existing items
- Process in batches of 50 items max
- Report both successes and failures separately
- For updates, show the diff (old value → new value)

