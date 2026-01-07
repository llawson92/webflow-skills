---
name: site-diagnostics
description: Gather site configuration and status for troubleshooting Webflow issues. Shows domains, SSL status, last publish, and identifies common problems.
---

# Site Diagnostics

Gather site status for troubleshooting.

## Instructions

1. **Get site**: Identify the target site
2. **Check configuration**: Domains, SSL, hosting
3. **Check status**: Last publish, pending changes
4. **Check accessibility**: Test key URLs
5. **Identify issues**: Flag common problems
6. **Generate report**: Status with recommendations

## Examples

**User prompt:**
```
My site seems broken. Run diagnostics.
```

**Response format:**
```
🔧 Diagnostics: Company Site

Configuration:
├── Domain: www.company.com ✓
├── SSL: Valid (expires Feb 2026)
└── Hosting: CMS Plan

Status:
├── Last publish: 2 hours ago
├── Pending changes: 3 pages modified
└── Site accessible: ✓ (234ms)

No critical issues detected.

Suggestions:
└── 3 pages have unpublished changes
```

**When issues found:**
```
🔧 Diagnostics: Company Site

🚨 Issue Detected:
├── www.company.com: Connection timeout
└── company.webflow.io: ✓ Working

Diagnosis: DNS not pointing to Webflow

Fix:
1. Check domain registrar
2. Verify CNAME points to proxy-ssl.webflow.com
```

## Guidelines

- Check both custom domain and webflow.io
- Report SSL expiration if within 30 days
- Identify DNS/domain issues specifically
- This is read-only, no confirmation needed

