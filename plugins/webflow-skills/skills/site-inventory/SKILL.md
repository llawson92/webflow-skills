---
name: site-inventory
description: Export a complete inventory of a Webflow site including all pages, CMS collections, and item counts. Use for migration planning, documentation, or understanding site structure.
---

# Site Inventory

Export a complete inventory of a Webflow site's structure.

## Instructions

1. **Get site**: Identify the target site
2. **List pages**: Get all static and CMS pages
3. **List collections**: Get all CMS collections with field schemas
4. **Count items**: Tally items in each collection
5. **Generate report**: Format as a structured inventory

## Examples

**User prompt:**
```
Give me a complete inventory of my site.
```

**Response format:**
```
📊 Site Inventory: Company Site

Pages (12 total):
├── Static: Home, About, Contact, Privacy...
└── CMS Templates: Blog Post, Team Member...

CMS Collections (3):
├── Blog Posts: 47 items
│   └── Fields: title, slug, content, author, date
├── Team: 8 items
│   └── Fields: name, role, bio, photo
└── Categories: 6 items
    └── Fields: name, slug

Last published: January 5, 2025
```

## Guidelines

- Organize pages by type (static vs CMS)
- Show field schemas for collections
- Include item counts
- Include last publish date if available
- This is read-only, no confirmation needed

