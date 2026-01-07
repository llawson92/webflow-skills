# Contributing

Guidelines for adding and improving Webflow skills.

## Adding a New Skill

### 1. Create the Skill Directory

```
plugins/webflow-skills/skills/
└── my-skill/
    └── SKILL.md
```

### 2. Write SKILL.md

Use YAML frontmatter followed by markdown content:

```markdown
---
name: my-skill
description: Clear description of what this skill does and when to use it. Include keywords that help agents identify when this skill is relevant.
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
- Keep `SKILL.md` under 500 lines

### Optional Fields

```yaml
---
name: my-skill
description: What this skill does
license: MIT
model: sonnet
allowed-tools: Read Grep Glob
---
```

## Quality Checklist

- [ ] `SKILL.md` has name and description in frontmatter
- [ ] Instructions section explains how to perform the task
- [ ] Examples show realistic prompts and responses
- [ ] Guidelines cover edge cases

## Pull Requests

1. Test the skill with Claude
2. Title format: `feat(skills): Add [skill-name]`
3. Explain what the skill does and why

## Issues

**Bug reports**: Skill name, steps to reproduce, expected vs actual

**Feature requests**: Proposed skill, use case, expected behavior
