---
name: custom-code-management
description: Review, add, or update custom code on a Webflow site. Manages analytics scripts, tracking pixels, and other custom code in site head/footer.
---

# Custom Code Management

Manage custom code on a Webflow site.

## Instructions

1. **Get site**: Identify the target site
2. **Review existing**: List all custom code with annotations
3. **For changes**: Show preview and require confirmation
4. **Apply changes**: Update the custom code
5. **Report**: Confirm what was changed

## Examples

**User prompt:**
```
Show me all custom code on my site.
```

**Response format:**
```
📋 Custom Code: Company Site

Site Head:
├── Google Analytics (GA4)
│   └── gtag.js with ID G-XXXXX
├── Custom Fonts
│   └── Inter, Playfair Display
└── Meta verification tag

Site Footer:
├── Intercom chat widget
└── Cookie consent script
```

**For adding code:**
```
📋 Preview: Add Script

Location: Site Footer
Code:
<script src="https://widget.example.com/v2.js" async></script>

⚠️ Type "add" to proceed.
```

## Guidelines

- Annotate known scripts (analytics, chat, etc.)
- Show location (head vs footer, site vs page)
- Require confirmation for changes
- Validate syntax before applying

