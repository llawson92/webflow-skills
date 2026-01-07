---
name: cms-best-practices
description: Expert guidance on Webflow CMS architecture and best practices. Use when planning collections, setting up relationships, optimizing content structure, or troubleshooting CMS issues.
---

# CMS Best Practices

Provide expert guidance on Webflow CMS architecture, relationships, and optimization.

## Instructions

1. **Understand the use case**: What content is being managed and how will it be displayed?
2. **Recommend structure**: Suggest collections, fields, and relationships
3. **Explain tradeoffs**: Help users understand limitations and workarounds
4. **Optimize for scale**: Consider performance with large datasets

## Collection Architecture

### When to Use CMS vs Static

**Use CMS when:**
- Content updates frequently
- Multiple similar items (blog posts, products, team members)
- Non-technical users need to edit content
- Content needs filtering/sorting on the frontend
- Same content appears on multiple pages

**Use Static when:**
- Content rarely changes
- Unique one-off sections
- Complex custom layouts per item
- No need for dynamic filtering

### Field Type Selection

| Content Type | Recommended Field | Notes |
|--------------|-------------------|-------|
| Short text (<256 chars) | Plain Text | Titles, names, slugs |
| Long text (no formatting) | Plain Text (long) | Descriptions, excerpts |
| Formatted content | Rich Text | Blog content, bios |
| Single image | Image | Photos, thumbnails |
| Multiple images | Multi-image | Galleries |
| File downloads | File | PDFs, documents |
| Yes/No values | Switch | Featured flags, visibility |
| Single choice | Option | Status, category type |
| Date/time | Date/Time | Publish dates, events |
| Link to other item | Reference | Author → Post |
| Link to multiple items | Multi-reference | Post → Tags |
| External URL | Link | Social links, external resources |
| Numeric values | Number | Prices, ratings, order |
| Color values | Color | Theme colors, accents |

## Relationship Patterns

### One-to-Many (Reference Field)

**Example:** Posts → Author
```
Authors Collection:
├── name (Text)
├── bio (Rich Text)
└── photo (Image)

Posts Collection:
├── title (Text)
├── content (Rich Text)
└── author (Reference → Authors)  ← Each post has ONE author
```

**Display:** On post page, access `author.name`, `author.photo`

### Many-to-Many (Multi-Reference)

**Example:** Posts ↔ Tags
```
Tags Collection:
├── name (Text)
└── slug (Text)

Posts Collection:
├── title (Text)
├── content (Rich Text)
└── tags (Multi-Reference → Tags)  ← Each post has MANY tags
```

**Limitations:**
- Max 5 multi-reference fields per collection
- Can only filter by ONE multi-reference value at a time
- Cannot sort by referenced field values

### Nested Collections Pattern

For hierarchical content (Categories → Subcategories):
```
Categories Collection:
├── name (Text)
├── slug (Text)
└── parent (Reference → Categories)  ← Self-reference for hierarchy
```

**Alternative:** Use Option field for simple categorization instead.

## Examples

**User prompt:**
```
I'm building a recipe site. How should I structure the CMS?
```

**Response format:**
```
📐 CMS Architecture: Recipe Site

Collections needed:

1. Recipes (main content)
├── name (Text, required)
├── slug (Text, required)
├── description (Plain Text)
├── featured-image (Image)
├── prep-time (Number) - minutes
├── cook-time (Number) - minutes
├── servings (Number)
├── difficulty (Option: Easy, Medium, Hard)
├── ingredients (Rich Text)
├── instructions (Rich Text)
├── author (Reference → Authors)
├── category (Reference → Categories)
├── tags (Multi-Reference → Tags)
├── featured (Switch)
└── publish-date (Date)

2. Categories
├── name (Text)
├── slug (Text)
├── description (Plain Text)
└── image (Image)

3. Tags
├── name (Text)
└── slug (Text)

4. Authors
├── name (Text)
├── bio (Rich Text)
├── photo (Image)
└── social-link (Link)

Relationships:
- Recipe → Author (one-to-many)
- Recipe → Category (one-to-many)
- Recipe → Tags (many-to-many)

Recommended pages:
- /recipes (Collection List with filters)
- /recipes/[slug] (Collection Page)
- /categories/[slug] (filtered recipe list)
- /authors/[slug] (author profile + their recipes)
```

**User prompt:**
```
My collection list is slow with 500+ items. How do I optimize?
```

**Response format:**
```
⚡ CMS Performance Optimization

Current issue: Loading 500+ items impacts page speed.

Recommendations:

1. **Pagination**
   - Limit collection list to 12-20 items
   - Add "Load More" button or page navigation
   - Use Webflow's built-in pagination

2. **Lazy loading images**
   - Set images to load="lazy"
   - Use appropriate image sizes (not full resolution)

3. **Reduce reference field lookups**
   - Each reference field = additional query
   - Consider denormalizing (copy author name to post)
   - Only include reference fields you display

4. **Filter at collection level**
   - Don't load all items then hide with conditions
   - Use collection list filters to limit results

5. **Consider static for archives**
   - Recent 50 items: dynamic CMS
   - Older content: static archive pages

Quick wins:
├── Limit to 20 items per page ✓
├── Enable pagination ✓
├── Remove unused reference bindings ✓
└── Optimize image sizes ✓
```

## Common Questions

### "How many collections can I have?"
- Starter: 1 collection, 50 items
- Basic: 2 collections, 200 items  
- CMS: 20 collections, 2,000 items
- Business: 40 collections, 10,000 items
- Enterprise: Custom limits

### "Can I filter by multiple tags?"
Not directly. Workarounds:
1. Create combined tag (e.g., "vegan-gluten-free")
2. Use Finsweet CMS Filter for client-side filtering
3. Create separate filtered collection lists

### "How do I reorder items?"
1. Add a Number field called "order" or "sort-order"
2. Set collection list to sort by that field
3. Update numbers to change order

### "Can I schedule posts?"
Yes! Use a Date field for "publish-date" and:
1. Filter collection list: Publish Date < Today
2. Items with future dates won't show

### "Should I use Rich Text or separate fields?"
- **Rich Text:** Flexible content, blog posts, articles
- **Separate fields:** Structured data you need to style individually

## Guidelines

- Plan collection structure before building pages
- Use descriptive field names (not "text-1", "image-2")
- Add help text to fields for content editors
- Set required fields for essential data
- Use Option fields instead of free text for controlled values
- Create test items before building collection templates
- Consider URL structure early (/blog/[slug] vs /posts/[slug])
- Document your CMS structure for team members

