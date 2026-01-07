---
name: page-content-update
description: Update static page metadata on a Webflow site. Can update meta titles, descriptions, OG tags, and slugs with preview before applying.
---

# Page Content Update

Update page metadata on a Webflow site.

## Instructions

1. **Get target**: Site and page to update
2. **Get current values**: Show existing metadata
3. **Preview changes**: Show diff of old vs new
4. **Confirm**: Wait for approval
5. **Apply**: Update the page
6. **Report**: Confirm changes

## Examples

**User prompt:**
```
Update the meta description for my /about page.
```

**Response format:**
```
📝 Page Update: /about

Current:
├── Title: "About"
└── Description: (empty)

Proposed:
├── Title: "About" (unchanged)
└── Description: "Learn about our mission and team."

⚠️ Type "update" to proceed.
```

**After confirmation:**
```
✅ Page Updated

/about
└── Description: Added (156 chars)

Changes saved to draft. Publish to make live.
```

## Guidelines

- Show current values before changes
- Display diff clearly
- Warn about slug changes (breaks links)
- Remind that changes need publish to go live
- Require confirmation for any changes

