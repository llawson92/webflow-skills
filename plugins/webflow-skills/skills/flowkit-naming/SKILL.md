---
name: flowkit-naming
description: Apply Flowkit CSS naming system in Webflow. Use when creating classes, auditing existing naming, or building new components following Flowkit conventions.
---

# Flowkit Naming System

Help users apply the Flowkit CSS naming convention in Webflow projects.

## Instructions

1. **Identify the task**: Determine if user is creating new classes, auditing existing, or building components
2. **Apply naming rules**: Follow Flowkit structure for all class suggestions
3. **Explain reasoning**: Help users understand why certain names follow the system

## Naming Structure

Flowkit uses a flat, utility-first approach with semantic component naming.

### Core Patterns

| Pattern | Purpose | Example |
|---------|---------|---------|
| `fk-[component]` | Component wrapper | `fk-card`, `fk-nav`, `fk-hero` |
| `fk-[component]-[element]` | Child element | `fk-card-title`, `fk-nav-link` |
| `fk-[component].[modifier]` | Combo class modifier | `fk-card.is-featured` |
| `fk-text-[style]` | Typography utility | `fk-text-xl`, `fk-text-bold` |
| `fk-flex` / `fk-grid` | Layout utilities | `fk-flex-center`, `fk-grid-3` |
| `fk-space-[size]` | Spacing utilities | `fk-space-md`, `fk-py-lg` |
| `is-[state]` | State modifiers | `is-active`, `is-hidden` |

### Layout Utilities

```
fk-section         Section wrapper with padding
fk-container       Max-width container
fk-flex            Flexbox container
fk-flex-center     Centered flex
fk-flex-between    Space-between flex
fk-grid            Grid container
fk-grid-2          2-column grid
fk-grid-3          3-column grid
fk-grid-4          4-column grid
fk-stack           Vertical stack
fk-row             Horizontal row
```

### Typography Utilities

```
fk-text-xs         Extra small text
fk-text-sm         Small text
fk-text-md         Medium text (default)
fk-text-lg         Large text
fk-text-xl         Extra large text
fk-text-2xl        2x large text
fk-text-bold       Bold weight
fk-text-light      Light weight
fk-text-center     Center aligned
fk-text-uppercase  Uppercase transform
```

### Spacing Utilities

```
fk-space-xs        4px
fk-space-sm        8px
fk-space-md        16px
fk-space-lg        24px
fk-space-xl        32px
fk-space-2xl       48px
fk-py-[size]       Padding vertical
fk-px-[size]       Padding horizontal
fk-my-[size]       Margin vertical
fk-mx-[size]       Margin horizontal
```

## Examples

**User prompt:**
```
Build a feature grid section using Flowkit naming.
```

**Response format:**
```
📐 Flowkit Classes for Feature Grid

Section structure:
fk-section
└── fk-container
    ├── fk-features-header + fk-text-center + fk-space-xl
    │   ├── fk-features-label + fk-text-sm + fk-text-uppercase
    │   ├── fk-features-title + fk-text-2xl
    │   └── fk-features-subtitle + fk-text-lg
    └── fk-features-grid + fk-grid-3
        └── fk-feature (repeated)
            ├── fk-feature-icon
            ├── fk-feature-title + fk-text-lg
            └── fk-feature-text + fk-text-md

Responsive modifier:
fk-grid-3.tablet-2.mobile-1 (grid columns per breakpoint)
```

**User prompt:**
```
Check these classes against Flowkit: feature-card, FK-Button, fk_hero_title
```

**Response format:**
```
📋 Flowkit Audit

| Current | Issue | Suggested |
|---------|-------|-----------|
| feature-card | Missing fk- prefix | fk-feature-card or fk-card |
| FK-Button | Wrong case (should be lowercase) | fk-button |
| fk_hero_title | Underscores not used | fk-hero-title |

Pattern reminder: fk-[component]-[element] with hyphens only.
```

## Guidelines

- Always prefix with `fk-` for namespacing
- Use hyphens to separate words, never underscores
- All class names are lowercase
- Modifiers are combo classes with `is-` prefix or dot notation
- Utility classes can be combined freely
- Keep component names concise
- Responsive modifiers use breakpoint suffix: `.tablet-`, `.mobile-`

## Common Patterns

**Page section:**
```
fk-section
└── fk-container
    └── fk-[name]-wrapper + fk-py-xl
        ├── fk-[name]-header + fk-text-center
        └── fk-[name]-content
```

**Card component:**
```
fk-card
├── fk-card-image
├── fk-card-content + fk-space-md
│   ├── fk-card-tag + fk-text-xs + fk-text-uppercase
│   ├── fk-card-title + fk-text-lg
│   └── fk-card-text
└── fk-card-footer
    └── fk-card-link

With modifier:
fk-card.is-featured (highlighted card)
fk-card.is-horizontal (side-by-side layout)
```

**Navigation:**
```
fk-nav
├── fk-nav-logo
├── fk-nav-menu + fk-flex-center
│   └── fk-nav-link (repeated)
│       └── fk-nav-link.is-active
└── fk-nav-actions
    └── fk-button.is-primary
```

**Button variations:**
```
fk-button              (base)
fk-button.is-primary   (filled)
fk-button.is-secondary (outline)
fk-button.is-small     (size)
fk-button.is-large     (size)
fk-button.is-icon      (icon only)
```

**Responsive grid:**
```
fk-grid-4.tablet-2.mobile-1
└── fk-grid-item (repeated)
```

