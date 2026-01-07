---
name: asset-audit
description: Analyze assets on a Webflow site for optimization opportunities. Lists all images and files, identifies large files, and suggests compression or format changes.
---

# Asset Audit

Analyze assets on a Webflow site for optimization.

## Instructions

1. **Get site**: Identify the target site
2. **List assets**: Get all assets with sizes
3. **Analyze**: Identify large files and optimization opportunities
4. **Generate report**: Show findings with recommendations

## Examples

**User prompt:**
```
Run an asset audit on my site.
```

**Response format:**
```
📊 Asset Audit: Company Site

Total: 89 assets (67 MB)

⚠️ Large Files (>1MB):
├── hero-image.png (8.4 MB) - Convert to WebP
├── team-photo.jpg (5.4 MB) - Resize and compress
└── background.png (3.2 MB) - Convert to WebP

Recommendations:
1. Convert 12 PNGs to WebP (~15 MB savings)
2. Compress 8 large JPGs (~8 MB savings)

Potential savings: ~23 MB (34% reduction)
```

## Guidelines

- Group assets by type and size
- Flag files over 1MB
- Suggest specific optimizations
- Calculate potential savings
- This is read-only, no confirmation needed

