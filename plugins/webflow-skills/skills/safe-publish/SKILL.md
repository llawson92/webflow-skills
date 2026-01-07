---
name: safe-publish
description: Publish a Webflow site with a plan-confirm-publish workflow. Shows what changed since last publish and requires explicit confirmation before going live.
---

# Safe Publish

Publish a Webflow site with preview of changes and explicit confirmation.

## Instructions

1. **Get site info**: Identify the target site
2. **Gather changes**: List pages and CMS items modified since last publish
3. **Show preview**: Display what will go live
4. **Require confirmation**: Wait for explicit "publish" command
5. **Execute publish**: Call the publish API
6. **Verify**: Check that the site is accessible after publishing

## Examples

**User prompt:**
```
Publish my site. Show me what changed first.
```

**Response format:**
```
🚀 Publish Preview: Company Site

Last published: January 5, 2025

Changes to publish:
├── Pages: 2 modified
│   └── /about, /contact
├── Blog Posts: +3 new
└── Products: 1 updated

⚠️ Type "publish" to make these changes live.
```

**After confirmation:**
```
✅ Published successfully!

Site: Company Site
Published at: 2025-01-07 14:32 UTC

Verification:
├── Site accessible: ✓
└── Response time: 234ms
```

## Guidelines

- Always show what will change before publishing
- Require typing "publish" to confirm (not just "yes")
- Report the timestamp of publish
- Verify site is accessible after publishing
- If verification fails, report it clearly but note changes are live

