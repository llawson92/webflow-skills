---
name: client-first-naming
description: Apply Finsweet's Client-First CSS naming system in Webflow. Use when creating classes, auditing existing naming, or building new components following Client-First conventions.
---

# Client-First Naming System

Help users apply Finsweet's Client-First CSS naming convention in Webflow projects.

## Instructions

1. **Identify the task**: Determine if user is creating new classes, auditing existing, or building components
2. **Apply naming rules**: Follow Client-First structure for all class suggestions
3. **Explain reasoning**: Help users understand why certain names follow the system

## Naming Structure

Client-First uses this pattern: `[identifier]_[element-name]`

### Core Identifiers

| Identifier | Purpose | Example |
|------------|---------|---------|
| `section_` | Page section wrappers | `section_hero`, `section_about` |
| `container_` | Width-constraining containers | `container_large`, `container_small` |
| `padding-global` | Global horizontal padding | `padding-global` |
| `padding-section-` | Vertical section spacing | `padding-section-large` |
| `component_` | Reusable component wrappers | `component_navbar`, `component_card` |
| `[component]_` | Elements inside a component | `navbar_link`, `card_image` |
| `button` | Button styles | `button`, `is-primary`, `is-large` |
| `text-` | Typography utilities | `text-size-large`, `text-weight-bold` |
| `heading-style-` | Heading variants | `heading-style-h1`, `heading-style-h2` |
| `icon-` | Icon sizes/styles | `icon-1x1-small`, `icon-embed` |
| `is-` | State/modifier classes | `is-active`, `is-dark`, `is-mobile` |
| `hide-` | Responsive visibility | `hide-tablet`, `hide-mobile-portrait` |

### Breakpoint Names

- `desktop` (default, no suffix)
- `tablet`
- `mobile-landscape`
- `mobile-portrait`

## Examples

**User prompt:**
```
I'm building a pricing section with cards. What classes should I use?
```

**Response format:**
```
📐 Client-First Classes for Pricing Section

Section wrapper:
└── section_pricing

Container:
└── padding-global
    └── container_large
        └── padding-section-large

Content structure:
├── pricing_header
│   ├── pricing_label (use text-size-small)
│   └── pricing_heading (use heading-style-h2)
├── pricing_list (grid wrapper)
└── pricing_item (individual card)

Card component:
├── pricing_card
│   ├── pricing_card-header
│   ├── pricing_card-price
│   ├── pricing_card-features
│   └── pricing_card-button (use button is-primary)
```

**User prompt:**
```
Audit these classes: hero-section, heroTitle, btn-primary, sec-about
```

**Response format:**
```
📋 Client-First Audit

| Current | Issue | Suggested |
|---------|-------|-----------|
| hero-section | Missing identifier | section_hero |
| heroTitle | camelCase, no identifier | hero_title + heading-style-h1 |
| btn-primary | Non-standard prefix | button is-primary |
| sec-about | Abbreviated identifier | section_about |

Summary: 4 classes need renaming for Client-First compliance.
```

## Guidelines

- Always use lowercase with hyphens (not camelCase or underscores in element names)
- Underscore `_` separates identifier from element name
- Hyphen `-` separates words within element names
- Component children inherit the component name: `navbar_link`, `navbar_logo`
- Use utility classes for typography: `text-size-`, `text-weight-`, `text-color-`
- States/modifiers use `is-` prefix as combo classes
- Global styles (button, text utilities) don't need component prefix
- Folder structure in Webflow: organize by identifier in the Style Panel

## Common Patterns

**Page section:**
```
section_[name]
└── padding-global
    └── container_[size]
        └── padding-section-[size]
            └── [name]_component
```

**Component:**
```
component_[name] (optional wrapper)
└── [name]_wrapper
    ├── [name]_content
    └── [name]_image-wrapper
        └── [name]_image
```

**Button variations:**
```
button                    (base)
button is-primary         (filled)
button is-secondary       (outline)
button is-small          (size modifier)
button is-icon           (icon button)
```

