---
name: pre-publish-qa
description: Run quality checks on a Webflow site before publishing. Checks for missing required fields, broken references, SEO issues, and validation problems.
---

# Pre-Publish QA

Run quality checks before publishing a Webflow site.

## Instructions

1. **Get site**: Identify the target site
2. **Check pages**: Scan for SEO metadata issues
3. **Check CMS items**: Validate required fields and references
4. **Categorize issues**: Group by severity (critical, warning, info)
5. **Generate report**: Show issues with recommendations

## Examples

**User prompt:**
```
Check my site for issues before I publish.
```

**Response format:**
```
🔍 Pre-Publish QA: Company Site

⛔ Critical (2):
1. Broken reference: Blog Posts → "Q4 Update" has deleted author
2. Empty required field: Services → "Consulting" missing description

⚠️ Warnings (4):
├── /about - Missing meta description
├── /contact - Meta title too short
└── 2 blog posts missing featured images

✅ Passed: 45 checks

Recommendation: Fix critical issues before publishing.
```

## Guidelines

- Prioritize issues by severity
- Critical = blocks publishing or causes errors
- Warning = impacts SEO or user experience
- Provide specific fix instructions
- This is read-only, no confirmation needed

