---
name: lumos-naming
description: Apply Lumos CSS naming system in Webflow. Use when creating classes, auditing existing naming, or building new components following Lumos conventions.
---

# Lumos Naming System

Help users apply the Lumos CSS naming convention in Webflow projects.

## Instructions

1. **Identify the task**: Determine if user is creating new classes, auditing existing, or building components
2. **Apply naming rules**: Follow Lumos structure for all class suggestions
3. **Explain reasoning**: Help users understand why certain names follow the system

## Naming Structure

Lumos uses BEM-inspired naming with clear separation: `block_element-modifier`

### Core Patterns

| Pattern | Purpose | Example |
|---------|---------|---------|
| `block_` | Parent component | `card_`, `nav_`, `hero_` |
| `block_element` | Child element | `card_title`, `nav_link` |
| `block_element-modifier` | Variation | `card_title-large` |
| `l-` | Layout utilities | `l-grid`, `l-flex`, `l-container` |
| `t-` | Typography | `t-h1`, `t-body`, `t-label` |
| `u-` | Utilities | `u-hidden`, `u-margin-top` |
| `is-` | States | `is-active`, `is-visible` |
| `has-` | Conditional states | `has-icon`, `has-image` |

### Layout Classes

```
l-section          Section wrapper
l-container        Max-width container
l-grid             CSS Grid wrapper
l-flex             Flexbox wrapper
l-stack            Vertical stack with gap
l-cluster          Horizontal cluster with gap
```

### Typography Classes

```
t-display          Display text (largest)
t-h1 through t-h6  Heading levels
t-body             Body text
t-body-small       Smaller body
t-label            Labels/captions
t-link             Link styling
```

## Examples

**User prompt:**
```
I'm building a testimonial card component. What Lumos classes should I use?
```

**Response format:**
```
📐 Lumos Classes for Testimonial Card

Component structure:
testimonial_                    (block wrapper)
├── testimonial_quote          (quote text)
├── testimonial_author         (author wrapper)
│   ├── testimonial_avatar     (profile image)
│   ├── testimonial_name       (author name)
│   └── testimonial_role       (job title)
└── testimonial_rating         (optional stars)

With typography utilities:
├── testimonial_quote + t-body
├── testimonial_name + t-label
└── testimonial_role + t-body-small

Layout wrapper (if in grid):
l-grid
└── testimonial_ (repeated)
```

**User prompt:**
```
Check if these classes follow Lumos: TestimonialCard, quote-text, author_name
```

**Response format:**
```
📋 Lumos Audit

| Current | Issue | Suggested |
|---------|-------|-----------|
| TestimonialCard | PascalCase not allowed | testimonial_ |
| quote-text | Missing block prefix | testimonial_quote |
| author_name | Correct pattern ✓ | (keep as-is if block is "author") |

Recommendation: If these are all part of one testimonial component, 
use testimonial_ as the block prefix for consistency.
```

## Guidelines

- All lowercase with underscores separating block from element
- Hyphens for modifiers and multi-word elements
- Single underscore `_` between block and element
- Layout classes always start with `l-`
- Typography classes always start with `t-`
- Utility classes always start with `u-`
- State classes use `is-` or `has-` prefixes
- Keep block names short but descriptive

## Common Patterns

**Page section:**
```
l-section
└── l-container
    └── section-name_
        ├── section-name_header
        └── section-name_content
```

**Card grid:**
```
l-section
└── l-container
    └── l-grid
        └── card_ (repeated)
            ├── card_image
            ├── card_content
            │   ├── card_title + t-h4
            │   └── card_text + t-body
            └── card_footer
```

**Navigation:**
```
nav_
├── nav_logo
├── nav_menu
│   └── nav_link (repeated)
│       └── nav_link is-active (current page)
└── nav_actions
    └── nav_button
```

