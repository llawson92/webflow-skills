---
name: cms-collection-setup
description: Create a new CMS collection in Webflow with specified fields. Use when setting up blog posts, products, team members, or other content types.
---

# CMS Collection Setup

Create a new CMS collection with specified fields.

## Instructions

1. **Get requirements**: Collection name and field definitions
2. **Validate**: Check for name conflicts with existing collections
3. **Preview**: Show the schema that will be created
4. **Confirm**: Wait for approval
5. **Create**: Call the collection create API
6. **Report**: Show the new collection ID

## Examples

**User prompt:**
```
Create a Team Members collection with name, role, bio, and photo fields.
```

**Response format:**
```
📋 Preview: Create Collection

Name: Team Members
Slug: team-members

Fields:
├── name (Text, required)
├── slug (Text, required, auto-generate)
├── role (Text)
├── bio (Rich Text)
└── photo (Image)

⚠️ Type "create" to proceed.
```

**After confirmation:**
```
✅ Collection Created

Name: Team Members
ID: 64f1a2b3...

Ready to add items.
```

## Guidelines

- Always include name and slug as required fields
- Validate field types are supported
- Check for collection name conflicts
- Require confirmation before creating

