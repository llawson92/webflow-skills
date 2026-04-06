---
name: custom-code-management
description: Add, review, or remove inline custom scripts on a Webflow site (up to 10,000 chars). Use for analytics, tracking pixels, chat widgets, or any custom JavaScript. Also manages page-level scripts.
---

# Custom Code Management

Add, review, and manage inline custom scripts on a Webflow site — analytics, tracking pixels, chat widgets, or any custom JavaScript.

## Important Note

**ALWAYS use Webflow MCP tools for all operations:**
- Use Webflow MCP's `webflow_guide_tool` to get best practices **before any other tool call**
- Use Webflow MCP's `data_sites_tool` with action `list_sites` to identify available sites
- Use Webflow MCP's `data_scripts_tool` with action `list_registered_scripts` to list all registered scripts
- Use Webflow MCP's `data_scripts_tool` with action `list_applied_scripts` to list scripts applied to pages
- Use Webflow MCP's `data_scripts_tool` with action `add_inline_site_script` to register a new inline script
- Use Webflow MCP's `data_scripts_tool` with action `delete_all_site_scripts` to remove ALL site scripts (no selective delete)
- Use Webflow MCP's `data_scripts_tool` with action `get_page_script` to get custom code for a specific page
- Use Webflow MCP's `data_scripts_tool` with action `upsert_page_script` to add or update page-level custom code
- Use Webflow MCP's `data_scripts_tool` with action `delete_all_page_scripts` to remove all custom code from a page
- DO NOT use any other tools or methods for Webflow operations
- All tool calls must include the required `context` parameter (15-25 words, third-person perspective)
- Inline scripts only — max 10,000 characters per script
- Do NOT include `<script>` tags in script content (Webflow adds them automatically)

## Instructions

### Phase 1: Discovery
1. **Call `webflow_guide_tool` first** — always the first MCP tool call in any workflow
2. **Get the site**: Use `data_sites_tool` with action `list_sites` to identify the target site. If only one site exists, use it automatically.
3. **Identify the task type**:
   - **View/Audit**: List scripts, check what's installed → go to Phase 2
   - **Add/Update**: Add new script or update page code → go to Phase 3
   - **Remove**: Delete scripts → go to Phase 3

### Phase 2: Analysis (read-only operations)
4. **List registered scripts**: Use `data_scripts_tool` with action `list_registered_scripts` to see all scripts registered on the site
5. **List applied scripts**: Use `data_scripts_tool` with action `list_applied_scripts` to see where scripts are applied
6. **Check page-level scripts** (if relevant): Use `data_scripts_tool` with action `get_page_script` to inspect custom code on specific pages
7. **Present findings**: Summarize scripts by:
   - Name, version, and location (header/footer)
   - Registration vs application status
   - Character count and content preview
   - Page-level vs site-level scope

### Phase 3: Planning (before any mutation)
Before adding, updating, or deleting anything:
8. **Present the plan**: Describe exactly what will be changed
9. **Request explicit confirmation**:
   - For adding scripts: User must type **"add"** to confirm
   - For removing ALL site scripts: User must type **"delete all"** to confirm
   - For page-level changes: User must type **"update"** to confirm
10. **Warn about side effects**:
    - `delete_all_site_scripts` removes ALL scripts — there is no selective delete
    - Adding a script with an existing `displayName + version` will fail
    - Remind user that changes require publishing to go live

### Phase 4: Execution (after confirmation only)
11. **Add site script**: Use `data_scripts_tool` with action `add_inline_site_script`
    - Required fields: `displayName`, `sourceCode`, `version`, `location` (header/footer), `canCopy`
    - Validate: under 10,000 chars, no `<script>` tags
12. **Remove all site scripts**: Use `data_scripts_tool` with action `delete_all_site_scripts`
13. **Add/update page script**: Use `data_scripts_tool` with action `upsert_page_script`
14. **Remove page scripts**: Use `data_scripts_tool` with action `delete_all_page_scripts`

### Phase 5: Verification & Reporting
15. **Verify the change**: Re-list scripts to confirm the operation succeeded
16. **Report what changed**: Summarize the script name, location, version, and character count
17. **Remind about publishing**: Suggest using the `safe-publish` skill to publish changes to make them live

## Examples

### Example 1: View all scripts on a site

**User:** "What scripts are installed on my site?"

1. Call `webflow_guide_tool` for best practices
2. Call `data_sites_tool` with `list_sites` to identify the site
3. Call `data_scripts_tool` with `list_registered_scripts` and `list_applied_scripts` in parallel
4. Present organized summary of all scripts with name, version, location, and status

### Example 2: Add Google Tag Manager

**User:** "Add Google Tag Manager to my site"

1. Call `webflow_guide_tool` for best practices
2. Call `data_sites_tool` with `list_sites` to identify the site
3. Ask user for their GTM container ID (e.g., GTM-XXXXXXX)
4. Present plan: "I'll add a GTM script to the header with your container ID. Type **add** to confirm."
5. After confirmation: call `data_scripts_tool` with `add_inline_site_script`:
   - displayName: "Google Tag Manager"
   - sourceCode: GTM initialization snippet (without `<script>` tags)
   - version: "1.0.0"
   - location: "header"
   - canCopy: false
6. Verify by re-listing scripts
7. Remind user to publish

### Example 3: Remove all scripts

**User:** "Remove all custom scripts from my site"

1. Call `webflow_guide_tool` for best practices
2. Call `data_sites_tool` with `list_sites` to identify the site
3. Call `data_scripts_tool` with `list_registered_scripts` to show what will be deleted
4. Warn: "This will remove ALL scripts — there is no selective delete. Type **delete all** to confirm."
5. After confirmation: call `data_scripts_tool` with `delete_all_site_scripts`
6. Verify by re-listing scripts
7. Remind user to publish

### Example 4: Add a chat widget script

**User:** "Add an Intercom chat widget to my site"

1. Call `webflow_guide_tool` for best practices
2. Call `data_sites_tool` with `list_sites` to identify the site
3. Ask user for their Intercom app ID
4. Present plan with script preview and character count
5. After "add" confirmation: call `data_scripts_tool` with `add_inline_site_script`:
   - displayName: "Intercom Chat Widget"
   - sourceCode: Intercom initialization snippet
   - version: "1.0.0"
   - location: "footer"
   - canCopy: false
6. Verify and remind user to publish

### Example 5: Add page-specific tracking

**User:** "Add conversion tracking to my thank-you page"

1. Call `webflow_guide_tool` for best practices
2. Call `data_sites_tool` with `list_sites` to identify the site
3. Call `data_scripts_tool` with `get_page_script` to check existing page scripts
4. Present plan: "I'll add conversion tracking code to the thank-you page. Type **update** to confirm."
5. After confirmation: call `data_scripts_tool` with `upsert_page_script`
6. Verify by calling `get_page_script` again
7. Remind user to publish

## Guidelines

### Script Content Rules
- Maximum 10,000 characters per script
- Do NOT include `<script>` tags — Webflow adds them automatically
- `displayName` + `version` must be unique per site
- Use semantic version numbers (e.g., "1.0.0", "2.1.0")
- Use descriptive display names (e.g., "Google Tag Manager", not "GTM")

### Confirmation Requirements
- **Adding scripts**: Require user to type "add"
- **Deleting ALL site scripts**: Require user to type "delete all"
- **Updating page scripts**: Require user to type "update"
- Do NOT accept generic confirmations ("yes", "ok", "go") for destructive operations
- Always show a preview of the script content before adding

### Scope Awareness
- Site-level scripts (`add_inline_site_script`) apply to all pages
- Page-level scripts (`upsert_page_script`) apply to a specific page only
- `delete_all_site_scripts` removes ALL site-level scripts — no selective delete available
- `delete_all_page_scripts` removes all scripts from a specific page
- Hosted/external scripts are not available via MCP — only inline scripts

### Safety and Best Practices
- Always list existing scripts before adding new ones to avoid duplicates
- Warn users about the destructive nature of `delete_all_site_scripts`
- Remind users to publish after any script changes
- Suggest using the `safe-publish` skill for publishing
- For analytics scripts (GA, GTM), recommend header placement
- For chat widgets and non-critical scripts, recommend footer placement
- Validate script content doesn't contain malicious patterns

### Error Handling
- If `displayName + version` already exists, suggest incrementing the version
- If script exceeds 10,000 chars, suggest splitting or hosting externally
- If site has no scripts to delete, inform user — don't call delete
