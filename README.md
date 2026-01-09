# Webflow Skills

Agent skills for working with Webflow sites, following the [Agent Skills](https://github.com/anthropics/agent-skills) open format.

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

| Skill | Description |
|-------|-------------|
| bulk-cms-update | Create or update multiple CMS items with validation and preview |
| safe-publish | Plan-confirm-publish workflow with verification |
| site-audit | Comprehensive site audit with health scoring and actionable insights |
| cms-collection-setup | Create CMS collections from schema definitions |
| asset-audit | Analyze assets for optimization opportunities |
| custom-code-management | Safely manage tracking scripts and custom code |

## Repository Structure

```
webflow-skills/
├── .claude-plugin/
│   └── marketplace.json      # Marketplace manifest
├── plugins/
│   └── webflow-skills/
│       ├── .claude-plugin/
│       │   └── plugin.json   # Plugin manifest
│       └── skills/
│           ├── bulk-cms-update/
│           │   └── SKILL.md
│           ├── safe-publish/
│           │   └── SKILL.md
│           └── ...
├── AGENTS.md                 # Agent-facing documentation
├── CLAUDE.md                 # Symlink to AGENTS.md
└── README.md                 # This file
```

## Creating New Skills

Skills follow the [Agent Skills specification](https://github.com/anthropics/agent-skills). Each skill requires a `SKILL.md` file with YAML frontmatter.

### Skill Template

Create a new directory under `plugins/webflow-skills/skills/`:

```
plugins/webflow-skills/skills/my-skill/
└── SKILL.md
```

`SKILL.md` format:

```markdown
---
name: my-skill
description: A clear description of what this skill does and when to use it.
---

# My Skill Name

## Instructions

Step-by-step guidance for the agent.

## Examples

Concrete examples showing expected input/output.

## Guidelines

- Specific rules to follow
- Edge cases to handle
```

### Naming Conventions

- `name`: 1-64 characters, lowercase alphanumeric with hyphens only
- `description`: Up to 1024 characters, include trigger keywords
- Keep `SKILL.md` under 500 lines; split longer content into reference files

## License

MIT
