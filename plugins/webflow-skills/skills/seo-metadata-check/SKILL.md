---
name: seo-metadata-check
description: Audit SEO metadata across all pages of a Webflow site. Checks for missing or problematic meta titles, descriptions, and Open Graph tags.
---

# SEO Metadata Check

Audit SEO metadata across a Webflow site.

## Instructions

1. **Get site**: Identify the target site
2. **Scan pages**: Check all static and CMS pages
3. **Validate metadata**: Check titles, descriptions, OG tags
4. **Calculate score**: Overall SEO health
5. **Generate report**: Issues with recommendations

## Examples

**User prompt:**
```
Audit my site for SEO issues.
```

**Response format:**
```
🔍 SEO Audit: Company Site

Score: 72/100

Issues:
├── Missing meta descriptions: 4 pages
│   └── /about, /contact, /careers, /blog
├── Title too long: 2 pages
│   └── / (72 chars), /products (68 chars)
└── Missing OG images: 3 pages

Good:
├── All pages have titles
├── No duplicate titles
└── 18 pages fully optimized

Priority fixes:
1. Add descriptions to 4 pages
2. Shorten 2 titles to under 60 chars
```

## Guidelines

- Score based on completeness
- Check title length (50-60 chars ideal)
- Check description length (150-160 chars ideal)
- Flag duplicates
- This is read-only, no confirmation needed

