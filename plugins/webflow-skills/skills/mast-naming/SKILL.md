---
name: mast-naming
description: Apply Mast CSS naming system in Webflow. Use when creating classes, auditing existing naming, or building new components following Mast conventions.
---

# Mast Naming System

Help users apply the Mast CSS naming convention in Webflow projects.

## Instructions

1. **Identify the task**: Determine if user is creating new classes, auditing existing, or building components
2. **Apply naming rules**: Follow Mast structure for all class suggestions
3. **Explain reasoning**: Help users understand why certain names follow the system

## Naming Structure

Mast uses a semantic, component-based approach with clear hierarchy.

### Core Patterns

| Pattern | Purpose | Example |
|---------|---------|---------|
| `[Component]` | Component wrapper (PascalCase) | `Card`, `NavBar`, `Hero` |
| `[component]-[element]` | Child elements (lowercase) | `card-image`, `navbar-link` |
| `[component]-[element]--[mod]` | Modifiers | `card--featured`, `btn--primary` |
| `_[utility]` | Utility classes | `_flex`, `_grid`, `_hidden` |
| `_text-[style]` | Typography | `_text-lg`, `_text-bold` |
| `_space-[size]` | Spacing | `_space-md`, `_space-lg` |

### Component Classes (PascalCase wrappers)

```
Section          Page section wrapper
Container        Content container
Card             Card component
NavBar           Navigation bar
Hero             Hero section
Footer           Footer component
Modal            Modal dialog
```

### Element Classes (lowercase with hyphen)

```
[component]-wrapper      Inner wrapper
[component]-content      Content area
[component]-header       Header area
[component]-body         Body area
[component]-footer       Footer area
[component]-image        Image element
[component]-title        Title text
[component]-text         Body text
[component]-link         Link element
[component]-button       Button element
```

### Utility Prefixes

```
_flex            Flexbox display
_grid            Grid display
_hidden          Hide element
_visible         Show element
_text-[size]     Font size (sm, md, lg, xl)
_text-[weight]   Font weight (light, bold)
_text-[align]    Text alignment (center, right)
_space-[size]    Margin/padding utilities
_color-[name]    Color utilities
```

## Examples

**User prompt:**
```
I need to build a pricing table with Mast naming. What classes should I use?
```

**Response format:**
```
📐 Mast Classes for Pricing Table

Section wrapper:
Section
└── Container
    └── pricing-header
        ├── pricing-title + _text-xl
        └── pricing-subtitle + _text-md

Pricing grid:
pricing-grid + _grid
└── Card (repeated for each plan)
    ├── card-header
    │   ├── card-plan-name
    │   └── card-price
    ├── card-body
    │   └── card-features
    │       └── card-feature-item (repeated)
    └── card-footer
        └── card-button

Modifiers:
Card--featured     (highlighted plan)
card-button--primary  (CTA button)
```

**User prompt:**
```
Are these Mast-compliant? hero_title, HeroSection, hero-cta-btn
```

**Response format:**
```
📋 Mast Audit

| Current | Issue | Suggested |
|---------|-------|-----------|
| hero_title | Underscore not used for elements | hero-title |
| HeroSection | Combine into single word | Hero or HeroSection (pick one style) |
| hero-cta-btn | Abbreviation | hero-cta-button |

Notes:
- Use hyphens for element names, not underscores
- Keep component names simple PascalCase
- Avoid abbreviations (btn → button)
```

## Guidelines

- Component wrappers use PascalCase: `Card`, `NavBar`, `Hero`
- Child elements use lowercase-hyphen: `card-title`, `navbar-link`
- Modifiers use double-hyphen: `Card--featured`, `btn--large`
- Utilities start with underscore: `_flex`, `_text-lg`
- No abbreviations in element names (use `button` not `btn`)
- Keep nesting shallow (max 2-3 levels)
- Components should be self-contained and reusable

## Common Patterns

**Page section:**
```
Section
└── Container
    └── [section-name]-wrapper
        ├── [section-name]-header
        │   ├── [section-name]-title
        │   └── [section-name]-subtitle
        └── [section-name]-content
```

**Card component:**
```
Card
├── card-image-wrapper
│   └── card-image
├── card-content
│   ├── card-category + _text-sm
│   ├── card-title + _text-lg
│   └── card-excerpt
└── card-footer
    └── card-link
```

**Navigation:**
```
NavBar
├── navbar-logo
├── navbar-menu
│   └── navbar-link (repeated)
│       └── navbar-link--active (current)
└── navbar-actions
    └── navbar-button
```

**Button variations:**
```
Button              (base)
Button--primary     (filled style)
Button--secondary   (outline style)
Button--large       (size modifier)
Button--icon        (icon only)
```

