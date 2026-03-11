# Webflow Skills

A collection of [Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills) for working with Webflow sites through the Webflow MCP server. Manage CMS content, audit site health, optimize assets, and safely publish changes.

## Installing

These skills work with any agent that supports the Agent Skills standard, including Claude Code, Cursor, and others.

### Claude Code

Install using the [plugin marketplace](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/plugins#add-from-marketplace):

```
/plugin marketplace add webflow/webflow-skills
```

### Cursor

Install from the Cursor Marketplace or add manually via **Settings > Rules > Add Rule > Remote Rule (Github)** with `webflow/webflow-skills`.

### npx skills

Install using the [`npx skills`](https://skills.sh) CLI:

```
npx skills add https://github.com/webflow/webflow-skills
```

### Clone / Copy

Clone this repo and copy the skill folders into the appropriate directory for your agent:

| Agent | Skill Directory | Docs |
|-------|-----------------|------|
| Claude Code | `~/.claude/skills/` | [docs](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/skills) |
| Cursor | `~/.cursor/skills/` | [docs](https://docs.cursor.com/context/rules) |
| OpenCode | `~/.config/opencode/skills/` | [docs](https://opencode.ai/docs/skills/) |
| OpenAI Codex | `~/.codex/skills/` | [docs](https://developers.openai.com/codex/skills/) |
| Pi | `~/.pi/agent/skills/` | [docs](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent#skills) |

## Prerequisites

**Webflow MCP Server Required**

These skills require the [Webflow MCP server](https://developers.webflow.com/mcp) to be installed and configured. Without it, skills cannot access your Webflow sites.

### What You Need

1. **Webflow Account** - Active Webflow account with sites
2. **Webflow MCP Server** - Installed and configured in your MCP environment
3. **Compatible Agent** - Any agent with MCP and skills support enabled

### Quick Setup

1. **Add the Webflow MCP server** to your agent's MCP configuration
2. **Authenticate** with your Webflow account when prompted
3. **Verify** the connection by listing your Webflow sites

For detailed setup instructions, visit the [Webflow MCP Documentation](https://developers.webflow.com/mcp).

## Skills

| Skill | Description |
|-------|-------------|
| bulk-cms-update | Batch create/update CMS items with validation and preview |
| cms-collection-setup | Create collections with custom fields and relationships (16 field types) |
| cms-best-practices | Expert guidance on CMS architecture and optimization |
| site-audit | Comprehensive health check with scoring (0-100) and recommendations |
| asset-audit | Identify optimization opportunities for images and files |
| link-checker | Scan and fix broken/insecure links across pages and CMS content |
| accessibility-audit | WCAG 2.1 compliance check with detailed reports and fixes |
| safe-publish | Preview, confirm, publish workflow with verification |
| custom-code-management | Manage tracking scripts and custom code safely |
| flowkit-naming | Apply Webflow's official FlowKit CSS naming conventions |

## Resources

- [Webflow MCP Documentation](https://developers.webflow.com/mcp)
- [Prompt Library](https://developers.webflow.com/mcp/v1.0.0/examples) - Ready-to-use example prompts
- [Available Tools](https://developers.webflow.com/mcp/v1.0.0/reference/how-it-works#available-tools) - Complete tool reference
- [Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills) - Learn about the Agent Skills standard

## License

MIT
