---
name: site-activity
description: Query and summarize site activity logs for a Webflow enterprise site. Surfaces recent changes, identifies who made them, and generates human-readable activity reports. Use for site monitoring, change tracking, publish preparation, or weekly activity summaries. Enterprise plans only.
---

# Site Activity

Query, analyze, and summarize Webflow site activity logs for enterprise sites. Provides natural-language querying of recent changes, filtered summaries by event type or user, and formatted reports for team sharing.


## Important Note

**ALWAYS use Webflow MCP tools for all operations:**
- Use Webflow MCP's `data_sites_tool` with action `list_sites` for listing available sites
- Use Webflow MCP's `data_sites_tool` with action `get_site` for detailed site information
- Use Webflow MCP's `data_enterprise_tool` with action `list_site_activity_logs` for retrieving activity log events
- Use Webflow MCP's `webflow_guide_tool` to get best practices before starting
- DO NOT use any other tools or methods for Webflow operations
- All tool calls must include the required `context` parameter (15-25 words, third-person perspective)

**Enterprise Only:** Activity logs are only available for sites on Enterprise hosting plans. If the tool returns an error, inform the user that this feature requires an Enterprise plan.

**Tool Parameters for `list_site_activity_logs`:**
- `site_id` (required): The site's unique identifier
- `limit` (optional): Maximum records to return (max 100)
- `offset` (optional): Pagination offset for fetching beyond the first page

## Instructions

### Phase 1: Site Selection & Context
1. **Identify target site**: If the user does not provide a site ID, use `data_sites_tool` with action `list_sites` to list available sites and ask the user to select one.
2. **Verify enterprise plan**: The `list_site_activity_logs` tool requires an Enterprise hosting plan. If the call fails with a permissions error, inform the user that site activity logs are an enterprise-only feature.
3. **Fetch site details**: Use Webflow MCP's `data_sites_tool` with action `get_site` to retrieve:
    - Site name and ID
    - Last published date
    - Last updated date
    - Custom domains
4. **Infer intent from the prompt** (do not ask a follow-up question if the prompt is clear). Map the request to one of:
    - Recent activity summary ("what changed this week?")
    - Specific user's activity ("what did Sarah change?")
    - Specific activity type ("any CMS changes recently?")
    - Pre-publish review ("what's changed since last publish?")
    - General overview (default when the prompt is ambiguous)

    Only ask a clarifying question if the request is genuinely ambiguous (e.g., "show me activity" with no time window, user, or event type context).

### Phase 2: Fetch Activity Logs
5. **Fetch activity logs**: Use `list_site_activity_logs` with the site ID
    - Default to `limit: 100` (maximum per request) for comprehensive results
    - The API returns events in reverse chronological order (newest first)
6. **Handle pagination**: If the user needs older activity or the results suggest more data exists:
    - Use `offset` parameter to fetch additional pages
    - Combine results across pages for analysis
    - Warn the user if going back further than available data

### Phase 3: Analysis & Summarization
7. **Parse each activity log entry**: Each event contains:
    - `id`: Unique event identifier
    - `createdOn`: Timestamp (ISO 8601)
    - `lastUpdated`: Last update timestamp
    - `event`: Event type string (see Event Types below)
    - `user`: Object with `id` and `displayName` (absent for system events like backups)
    - `resourceOperation`: The operation performed (`CREATED`, `MODIFIED`, `DELETED`)
    - `resourceId`: ID of the affected resource (when applicable)
    - `resourceName`: Human-readable name of the affected resource
    - `payload`: Additional event-specific details (see Payload Details below)
8. **Categorize events** into human-readable groups (41 event types):

   **Page Changes:**
    - `page_dom_modified` — Page structure/element changes
    - `page_created` — New page creation
    - `page_deleted` — Page deletion
    - `page_duplicated` — Page duplication
    - `page_renamed` — Page rename
    - `page_settings_modified` — Page settings updates (SEO, slug, etc.)
    - `page_custom_code_modified` — Page-level custom code changes
    - `page_settings_custom_code_modified` — Page settings custom code changes

   **Style & Variable Changes:**
    - `styles_modified` — Style/class changes
    - `variable_modified` — Single variable change
    - `variables_modified` — Multiple variable changes

   **Component Changes:**
    - `symbols_modified` — Component/symbol created, modified, or deleted

   **Interactions:**
    - `ix2_modified_on_page` — Interaction changes on a page
    - `ix2_modified_on_component` — Interaction changes on a component
    - `ix2_modified_on_class` — Interaction changes on a class

   **CMS Changes:**
    - `cms_item` — Collection item created, modified, or deleted
    - `cms_collection` — Collection schema created, modified, or deleted

   **Site Management:**
    - `site_published` — Site published
    - `site_unpublished` — Site unpublished
    - `site_custom_code_modified` — Site-level custom code changes
    - `backup_created` — Automatic or manual backup
    - `backup_restored` — Backup restored

   **Localization:**
    - `secondary_locale_page_content_modified` — Localized page content changed
    - `locale_added` — New locale added
    - `locale_removed` — Locale removed
    - `locale_enabled` — Locale enabled
    - `locale_disabled` — Locale disabled
    - `locale_display_name_updated` — Locale display name changed
    - `locale_subdirectory_updated` — Locale subdirectory changed
    - `locale_tag_updated` — Locale tag changed

   **Branches:**
    - `branch_created` — Branch created
    - `branch_merged` — Branch merged
    - `branch_deleted` — Branch deleted
    - `branch_review_created` — Branch review requested
    - `branch_review_approved` — Branch review approved
    - `branch_review_canceled` — Branch review canceled

   **Library:**
    - `library_shared` — Library shared with other sites
    - `library_unshared` — Library unshared
    - `library_installed` — Library installed from another site
    - `library_uninstalled` — Library uninstalled
    - `library_update_shared` — Library update published
    - `library_update_accepted` — Library update accepted

   Note: If an event type not listed above appears, categorize it as "Other" and display the raw `event` string.
9. **Apply filters** based on user's request:
    - By event category (e.g., only CMS changes)
    - By user (match on `user.displayName`)
    - By time window (filter `createdOn` timestamps client-side)
    - By resource (match on `resourceName`)
    - **Pre-publish review**: When the user wants to see changes since the last publish, use the site's `lastPublished` timestamp (from Phase 1) and filter to events where `createdOn > lastPublished`. If `lastPublished` is null (never published), all events qualify as unpublished.
10. **Generate insights**:
    - Most active users in the time period
    - Most frequently changed resources
    - Event type distribution
    - Timeline of activity (busiest days/hours)
    - Burst of activity (many changes in a short period)
    - Single-user concentration (one person made most changes)
    - Unpublished changes (activity after last publish)

### Phase 4: Reporting
11. **Generate summary report**: Present findings in a clear, structured format:
    - Time range covered
    - Total event count
    - Breakdown by activity type
    - Breakdown by user
    - Notable patterns or highlights
12. **Answer the user's specific question**: If the user asked something specific, lead with the direct answer
13. **Offer detail levels**:
    - Quick summary: Event counts by category
    - Standard report: Categorized events with user attribution
    - Detailed report: Every event with full payload details
    - Export: Formatted for sharing (Markdown or structured text)
14. **Provide actionable context**: Highlight notable patterns such as:
    - High-frequency changes to a single page or collection
    - Multiple users editing the same resource
    - Unpublished changes (changes since last publish)
    - System events (backups) vs. user-initiated changes
15. **Always end every report with a follow-up options section.** This is required, not optional. Use the exact format below, tailoring the numbered options to what's relevant for the query just answered:

    ```
    ---

    Would you like to:
    1. Filter by a specific user
    2. Filter by activity type
    3. Fetch older activity (pagination)
    4. Export as markdown or JSON
    ```

    If the report was a shareable/export format (e.g., "summary I can share"), place this block **outside** the shareable content so the user can copy the report cleanly without the follow-up menu in it.

## Event Payload Details

Different event types include different payload fields:

**`page_dom_modified`:**
- `pageTitle`: Name of the modified page
- `pageId`: ID of the modified page
- `count`: Number of modifications in this batch
- `branchId`/`branchName`: Branch context (null if main)

**`cms_item`:**
- `cmsCollectionId`: ID of the parent collection
- `cmsCollectionName`: Name of the parent collection
- `count`: Number of items affected
- `name`: Locale name (e.g., "English", "Spanish")

**`styles_modified`:**
- `selector`: CSS selector (if applicable)
- `variant`: Breakpoint/pseudo-class variant string
- `parentChain`: Array of parent style names (combo class chain)
- `type`: Style type (e.g., "class")
- `branchId`/`branchName`: Branch context

**`symbols_modified`:**
- `branchId`/`branchName`: Branch context

**`page_settings_modified`:**
- `pageTitle`: Name of the modified page
- `branchId`/`branchName`: Branch context

**`backup_created`:**
- No payload; `resourceName` indicates backup type (e.g., "Automatic backup", "Maintenance backup")
- No `user` field (system-initiated)

## Examples


**User prompt:**
```
What happened on my site this week?
```

**Step 1: Site Selection**
```
📋 Site Activity — Site Selection

Available Enterprise Sites:

1. **Acme Corp Website**
   - Last published: April 14, 2026 at 18:30 UTC
   - Last updated: April 16, 2026 at 09:15 UTC
   - ⚠️ Has unpublished changes

2. **Acme Blog**
   - Last published: April 10, 2026 at 12:00 UTC
   - Last updated: April 10, 2026 at 12:00 UTC
   - ✅ Up to date

Which site would you like to review? (1-2)
```

**Step 2: Activity Summary**
```
📋 Site Activity: Acme Corp Website
   April 10–16, 2026 (93 events)

---

## Activity Breakdown

📄 Page modifications       34 events
🎨 Class changes            22 events
📝 CMS updates              18 events
🧩 Component changes         8 events
🔤 Variable changes          5 events
🚀 Publishes                 3 events
💾 Backups                   2 events
🌿 Branch activity           1 event

---

## Activity by User

**Sarah Chen** — 42 events
└── Page modifications (18), Class changes (15), CMS updates (9)

**Alex Kim** — 31 events
└── CMS updates (9), Page modifications (12), Component changes (8), Variables (2)

**Jordan Lee** — 17 events
└── Class changes (7), Page modifications (4), Publishes (3), Backups (2), Branch (1)

**System** — 3 events
└── Backups (auto)

---

## Highlights

- ⚠️ **Unpublished changes**: 28 events since last publish (Apr 14)
- 📊 **Busiest day**: April 15 (41 events)
- 👤 **Most active**: Sarah Chen (45% of all activity)
- 🧩 8 component changes by Alex Kim — may affect multiple pages

---

Would you like to:
1. Filter by a specific user
2. Filter by activity type
3. See details for unpublished changes only
4. Fetch older activity
```

**User prompt:**
```
Show me CMS changes on site 6924868ede9d3fbbc3195eb0
```

**Response:**
```
📋 CMS Activity: Acme Corp Website
   April 10–16, 2026

---

## CMS Changes (18 events)

**April 16**
├── 09:15 — Sarah Chen — CMS item modified
├── 09:10 — Sarah Chen — CMS item modified
└── 08:45 — Sarah Chen — CMS item created

**April 15**
├── 17:30 — Alex Kim — CMS item modified
├── 16:20 — Alex Kim — CMS items published (bulk)
├── 16:15 — Alex Kim — CMS item modified
├── 16:10 — Alex Kim — CMS item modified
├── 15:55 — Alex Kim — CMS item created
├── 14:30 — Sarah Chen — CMS item modified
├── 14:00 — Sarah Chen — CMS collection modified
└── 11:20 — Sarah Chen — CMS item created

**April 14**
├── 16:45 — Alex Kim — CMS item modified
├── 15:30 — Alex Kim — CMS item created
└── 14:00 — Sarah Chen — CMS item modified

**April 12**
├── 11:00 — Sarah Chen — CMS item modified
├── 10:45 — Sarah Chen — CMS item modified
├── 10:30 — Sarah Chen — CMS item created
└── 10:00 — Sarah Chen — CMS collection modified

---


Summary: 18 CMS events by 2 users over 5 days
- 5 items created, 11 items modified, 2 collection changes
- ⚠️ 3 CMS changes are unpublished (after Apr 14 publish)

---

Would you like to:
1. Filter to a specific collection
2. Filter by user (Sarah or Alex)
3. See only the unpublished CMS changes
4. Fetch older CMS activity
```

**User prompt:**
```
Give me a weekly summary I can share with my team
```

**Response:**
```
📋 Weekly Site Activity Report
   Acme Corp Website — Week of April 10–16, 2026

---

### Overview
- **93 total changes** across 3 team members
- **3 publishes** (Apr 10, Apr 12, Apr 14)
- **28 unpublished changes** pending review
- **Last publish:** April 14 at 18:30 UTC

### What Changed
- 34 page modifications across 8 pages
- 22 class/style updates
- 18 CMS content changes (5 new items, 11 edits, 2 schema changes)
- 8 component updates
- 5 variable changes

### Team Activity
| Team Member  | Changes | Top Activity                  |
|-------------|---------|-------------------------------|
| Sarah Chen  | 42      | Page edits, style updates     |
| Alex Kim    | 31      | CMS content, components       |
| Jordan Lee  | 17      | Styles, publishing, backups   |

### Action Items
- ⚠️ 28 changes are unpublished — consider reviewing and publishing
- 🧩 8 component changes may affect shared layouts — verify before publish
- 💾 Last backup: April 14 — consider creating a fresh backup

---
Generated from Webflow Site Activity Log
```

Would you like to:
1. Filter to a specific user's changes
2. Break down unpublished changes in detail
3. Regenerate with a different date range
4. Export as JSON instead of markdown


## Guidelines

### Enterprise-Only Access

**Plan Requirement:**
- `list_site_activity_logs` is available only on Enterprise hosting plans
- If the API returns a permissions error, clearly inform the user:
  ```
  ⚠️ Site Activity Logs require an Enterprise hosting plan.
  This site does not appear to have Enterprise access.
  ```
- Do not retry on permissions errors — the issue is plan-level, not transient

### API Constraints

**Pagination:**
- Maximum 100 events per request
- Use `offset` to paginate: first call offset=0, second call offset=100, etc.
- 100 events typically covers approximately one week for an active enterprise site
- No native date filtering — all filtering must be done client-side after fetching

**When to paginate:**
- User asks for more than one week of activity
- User needs a complete picture and first page returns exactly 100 events
- Always tell the user how much data you have: "Showing the last 93 events (Apr 10–16)"

**Rate awareness:**
- Avoid unnecessary pagination — fetch only what is needed to answer the question
- If user asks "any publishes recently?" — 100 events is likely enough
- If user asks "full month of activity" — explain the limitation and paginate up to 300 events maximum

### Analysis Best Practices

**Event Categorization:**
- Group events into human-readable categories (see Phase 3, step 8)
- Use plain language: "Page modifications" not "page_dom_modified"
- Combine related events: variable_modified and variables_modified both count as "Variable changes"

**Time Handling:**
- Show dates in human-readable format
- Group events by day for readability
- Calculate and show the time span covered
- Compare against the site's `lastPublished` to flag unpublished changes

**User Attribution:**
- Group activity by user when multiple users are active
- Show user display names, not IDs
- Highlight concentration of activity (one user doing 80%+ of changes)

### Reporting Formats

**Default — Structured Summary:**
- Lead with overview stats
- Break down by category and user
- End with highlights and action items

**Timeline View** (when user asks "what happened" or "walk me through"):
- Chronological list grouped by day
- Show timestamp, user, and event description per entry

**Shareable Report** (when user asks for something to share):
- Clean markdown format
- Include header with site name and date range
- Table format for team activity
- Action items section

### Error Handling

**Common errors:**
- **403 / Permission denied**: Enterprise plan required — inform user clearly
- **404 / Site not found**: Verify site ID, offer to list available sites
- **Empty results**: Site may have no recent activity — confirm with user and check site details

**Graceful degradation:**
- If site details fetch fails, still attempt activity logs
- If pagination fails mid-way, report what was successfully fetched
- Always show partial results rather than nothing

### Best Practices

**Always:**
- ✅ Verify enterprise access before querying
- ✅ Show the time range covered by results
- ✅ Translate event types to plain language
- ✅ Group by meaningful categories
- ✅ Flag unpublished changes
- ✅ Offer follow-up options

**Never:**
- ❌ Assume results cover a specific time period without checking
- ❌ Hide pagination limitations from the user
- ❌ Show raw API event type names without translation
- ❌ Make mutations — this is a read-only skill
- ❌ Retry on permission errors (plan-level issue)