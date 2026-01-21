# Webflow Skills

Production-ready agent skills for managing Webflow CMS content, auditing site health, optimizing assets, and safely publishing changes through Claude Code, following the [Agent Skills](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview) open format.

## Prerequisites

**⚠️ IMPORTANT: Webflow MCP Server Required**

These skills require the [Webflow MCP (Model Context Protocol) server](https://developers.webflow.com/mcp) to be installed and configured. The Webflow MCP server provides the connection between Claude Code and your Webflow sites.

### What You Need

1. **Webflow Account** - Active Webflow account with sites
2. **Webflow MCP Server** - Installed and configured in your MCP environment
3. **Claude Code** - With MCP support enabled

### Quick Setup

1. **Configure Webflow MCP in Claude Code**

   Add the Webflow MCP server to your Claude Code settings:

   ```bash
   claude mcp add --transport http webflow https://mcp.webflow.com/mcp
   ```

2. **Authenticate with Webflow**

   Follow the authentication prompts to connect your Webflow account.

3. **Verify Connection**

   Test the connection by asking Claude to list your Webflow sites.

Without the Webflow MCP server, these skills cannot access your Webflow sites and will not function.

For detailed installation and configuration instructions, visit the [Webflow MCP Documentation](https://developers.webflow.com/mcp).

---

## Installation

### Claude Code (via Marketplace)

```bash
# Add the marketplace
claude plugin marketplace add webflow/webflow-skills

# Install the plugin
claude plugin install webflow-skills@webflow-skills
```

### Claude Code (from local clone)

```bash
# Clone the repository
git clone git@github.com:webflow/webflow-skills.git ~/webflow-skills

# Install the plugin directly
claude plugin install ~/webflow-skills
```

After installation, restart Claude Code. The skills will be automatically invoked when relevant to your task.

### Updating

```bash
# Update the marketplace index
claude plugin marketplace update

# Update the plugin
claude plugin update webflow-skills@webflow-skills
```

Or use `/plugin` to open the interactive plugin manager.

### Other Agents

Copy the `skills/` directory to your agent's skills location, or reference the `SKILL.md` files directly according to your agent's documentation.

## Available Skills

### Content Management
- **bulk-cms-update** - Batch create/update CMS items with validation and preview
- **cms-collection-setup** - Create collections with custom fields and relationships (supports 16 field types)

### Site Health & Optimization
- **site-audit** - Comprehensive health check with scoring (0-100) and prioritized recommendations
- **asset-audit** - Identify optimization opportunities for images and files
- **link-checker** - Scan and fix broken/insecure links across pages and CMS content
- **accessibility-audit** - WCAG 2.1 compliance check for pages with detailed reports and fixes

### Publishing & Code
- **safe-publish** - Preview → Confirm → Publish workflow with verification
- **custom-code-management** - Manage tracking scripts and custom code safely

## Resources

- **Prompt Library**: [Ready-to-use example prompts](https://developers.webflow.com/mcp/v1.0.0/examples) to get started quickly
- **Available Tools**: [Complete tool reference](https://developers.webflow.com/mcp/v1.0.0/reference/how-it-works#available-tools) for all Webflow MCP capabilities

## License

MIT
