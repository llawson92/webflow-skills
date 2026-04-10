---
name: webflow-cli:cloud
description: Initialize, build, and deploy full-stack Webflow applications to Webflow Cloud hosting. Supports site-attached projects and apps (no site required). Use when creating new projects, deploying existing ones, or setting up CI/CD pipelines for Webflow Cloud.
---

# Webflow Cloud

Initialize new projects from templates and deploy to Webflow Cloud. Supports two modes: **site-attached** (connected to a Webflow site) and **app** (independent app, no site required).

## Instructions

### Tool usage

- Use the **Bash tool** for all `webflow cloud` commands
- Use the **Read tool** to examine `webflow.json`, `package.json` — never modify these directly
- Use the **Glob tool** to discover project files
- **Do not** use Webflow MCP tools for CLI workflows

### Authentication

```bash
# Interactive login (local dev)
webflow auth login
```

Environment variables read by the CLI:

| Variable | Required | Description |
|---|---|---|
| `WEBFLOW_SITE_API_TOKEN` | Yes (for deploy) | OAuth access token. Written to `.env` after `webflow auth login`. |
| `WEBFLOW_SITE_ID` | Site-attached only | Written to `.env` during `cloud init`. Absent for apps. |
| `DO_NOT_TRACK` | No | Set to `1` to opt out of telemetry. |

> **Note:** The CLI uses `WEBFLOW_SITE_API_TOKEN` (not `WEBFLOW_API_TOKEN`). Use `WEBFLOW_SITE_API_TOKEN` in GitHub Secrets. Never commit `.env` files.

### Configuration — webflow.json

```json
{
  "siteId": "site_abc123",
  "cloud": {
    "project_id": "proj_xyz",
    "framework": "nextjs",
    "skipMountPathCheck": false
  }
}
```

- `project_id` is **snake_case** — not `projectId`. Auto-set after the first deploy.
- `siteId` is absent for apps.
- `cloud.framework` resolution at deploy time:
  1. **`webflow.json` exists with `cloud.framework`** — used as-is. Invalid value exits with code 1.
  2. **`webflow.json` exists but `cloud.framework` is absent** — throws: _"webflow.json exists but doesn't contain valid framework information under the 'cloud' key"_. Add `"cloud": { "framework": "nextjs" }` manually.
  3. **No `webflow.json`** — auto-detected from `package.json`. CLI **writes a new `webflow.json`** on success.
- Projects created via `cloud init` always land in case 1.

### Commands

#### webflow cloud list

```bash
webflow cloud list
```

Lists available scaffold templates. Check this before `cloud init --framework` to confirm valid scaffold IDs.

#### webflow cloud init

Bootstrap a new project locally. Two modes: **site-attached** and **app**.

**Site-attached** (connects to an existing Webflow site):

```bash
# Interactive (local dev)
webflow cloud init

# Non-interactive (local one-time setup only — NOT for CI)
webflow cloud init \
  --no-input \
  --project-name my-app \
  --framework nextjs \
  --mount /app \
  --site-id site_abc123
```

Flags:

| Flag | Short | Description |
|---|---|---|
| `--project-name <name>` | `-n` | Project name. |
| `--framework <framework>` | `-f` | Must match a scaffold ID from `cloud list`. Currently: `nextjs`, `astro`. |
| `--mount <path>` | `-m` | Mount path (default `/app` for site-attached, `/` for app). Substituted into config files at scaffold time. Not stored in `webflow.json`. |
| `--site-id <id>` | `-s` | Required in non-interactive site-attached mode. |
| `--new` | — | App mode (no site). |
| `--no-input` | — | CI mode. Requires `--project-name` and `--framework`. Without `--new`, defaults to app behavior. |

Credential resolution for `--no-input` site-attached: `--site-id` flag → `siteId` in `webflow.json` → `WEBFLOW_SITE_ID` env var → error.

After scaffolding a site-attached project, the CLI automatically runs a **DevLink sync**.

**App** (no site attachment):

```bash
# Interactive
webflow cloud init --new

# Non-interactive (local only)
webflow cloud init --new --no-input --project-name my-app --framework nextjs
```

| | Site-attached | App (`--new`) |
|---|---|---|
| OAuth / site selection | Required at init | Skipped |
| `WEBFLOW_SITE_ID` in `.env` | Written | Not written |
| `WEBFLOW_SITE_API_TOKEN` in `.env` | Written | Not written |
| Scaffold | `astro`, `nextjs` | `astro`, `nextjs` |
| Mount path | Configurable (default `/app`) | Always `/` |
| DevLink sync | Runs after init | Skipped |

#### webflow cloud deploy

There are two deployment approaches. **GitHub-linked deployment is recommended** — it requires no CI configuration and deploys automatically on every push to the connected branch.

**Option 1 (recommended): GitHub-linked deployment**

Connect your repository to Webflow Cloud via the Webflow dashboard. Once linked, every push to the connected branch (typically `main`) triggers a deploy automatically — no CLI commands, no GitHub Actions needed.

1. Push your scaffolded project to GitHub
2. In the Webflow dashboard, open your Cloud project → **Settings** → **Git** and connect the repository
3. Select the branch to deploy from (e.g. `main`)
4. From that point on: `git push` = deploy

> When suggesting a deployment setup to a user, always lead with this option. Only suggest GitHub Actions if the user needs custom pre/post steps, secrets injection, or multi-environment logic that the native GitHub integration does not cover.

**Option 2: GitHub Actions (manual CI/CD)**

Use when you need custom build steps, environment-specific secrets, or deploy gates not supported by the native GitHub integration. See the [GitHub Actions example](#github-actions-cicd-pipeline) in the Examples section.

**Option 3: Local / manual deploy**

For development and one-off deploys:

```bash
webflow cloud deploy \
  --no-input \
  --mount / \
  --environment main \
  --skip-mount-path-check \
  --skip-update-check
```

All `cloud deploy` flags:

| Flag | Short | Description |
|---|---|---|
| `--no-input` | — | CI mode. Disables all prompts. |
| `--mount <path>` | `-m` | Mount path. **Always required with `--no-input`.** Not auto-read from `webflow.json`. |
| `--environment <env>` | `-e` | Environment name. Creates if it does not exist. Must be passed with `--mount`. |
| `--project-name <name>` | `-n` | Required on first deploy with `--no-input` when no `cloud.project_id` in `webflow.json`. |
| `--directory <path>` | `-d` | Project directory (default: cwd). Use for monorepos. |
| `--description <text>` | — | Project description for the first deploy. |
| `--skip-mount-path-check` | — | Skip domain manifest validation. Required in CI. Can also be set in `webflow.json` as `cloud.skipMountPathCheck: true`. |
| `--auto-publish` | — | Publish the Webflow **site** to sync mount path routing. Does not affect app deployment. |
| `--skip-update-check` | — | Skip @webflow package update check. |

### Frameworks

| Framework | Init scaffold | Deploy support | Detected via package |
|---|---|---|---|
| `nextjs` | ✓ | ✓ | `@opennextjs/cloudflare` |
| `astro` | ✓ | ✓ | `@astrojs/cloudflare` |
| `remix` | — (existing projects only) | ✓ | `@remix-run/cloudflare` |

Any other value in `cloud.framework` causes `cloud deploy` to exit with code 1.

### Global flags

| Flag | Description |
|---|---|
| `--no-input` | Disable all interactive prompts. Required for CI/automation. |
| `--manifest <path>` | Custom path to `webflow.json`. Use for monorepos. |
| `--skip-update-check` | Skip @webflow package update check. Alternatively, set `WEBFLOW_SKIP_UPDATE_CHECKS=true`. |

## Examples

### Full workflow: scaffold → GitHub → auto-deploy (recommended)

```bash
# 1. Scaffold locally
webflow cloud init --new --no-input --project-name my-app --framework nextjs

# 2. Push to GitHub
git init && git add . && git commit -m "init"
git remote add origin https://github.com/your-org/my-app.git
git push -u origin main

# 3. Connect in the Webflow dashboard:
#    New Project → App → Import a GitHub repository → select repo + branch → Deploy
#
# From now on, every push to main triggers a deploy automatically.
```

### Scaffold a site-attached Astro app locally

```bash
webflow cloud init \
  --no-input \
  --project-name my-site-app \
  --framework astro \
  --mount /app \
  --site-id site_abc123
```

### GitHub Actions CI/CD pipeline (when custom steps are needed)

```yaml
name: Deploy to Webflow Cloud

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install Webflow CLI
        run: npm install -g @webflow/webflow-cli@latest

      - name: Deploy
        run: |
          webflow cloud deploy \
            --no-input \
            --mount / \
            --environment main \
            --skip-mount-path-check \
            --skip-update-check
        env:
          WEBFLOW_SITE_API_TOKEN: ${{ secrets.WEBFLOW_SITE_API_TOKEN }}
          WEBFLOW_SITE_ID: ${{ secrets.WEBFLOW_SITE_ID }}
          # For apps, omit WEBFLOW_SITE_ID
```

### Manual deploy (local / one-off)

```bash
webflow cloud deploy \
  --no-input \
  --project-name my-app \
  --mount / \
  --environment main \
  --skip-mount-path-check \
  --skip-update-check
```

### Manual deploy with error handling

```bash
webflow cloud deploy --no-input --mount / --skip-mount-path-check --skip-update-check
if [ $? -ne 0 ]; then
  echo "Deploy failed. Log file:"
  webflow log
  exit 1
fi
```

## Guidelines

### Init vs Deploy in CI

- **`cloud init` is for local, one-time project setup — never run it in CI.** Site-attached mode opens a browser window; there is no headless OAuth path. Run `cloud init` once locally, commit the result, then use `cloud deploy` in CI.

### Mount path

- `--mount` is **always required** with `--no-input`. The CLI does not read a saved mount path from `webflow.json`.
- **Never assume a default.** Assuming `/` or `/app` will cause `ENVIRONMENT_MOUNT_MISMATCH` if the project uses a different path. Check the Webflow dashboard under the project's environment settings.

### Do not add confirmation gates

When `--no-input` is set, do not add a human confirmation step before `cloud deploy`. It blocks unattended CI runs and is unnecessary — the CLI has no built-in prompt to bypass.

### Package manager

The CLI uses **npm only** regardless of lock files present. pnpm and yarn lock files are ignored — those projects silently receive `npm install`.

### Build-time file management

During `cloud deploy`, the CLI temporarily replaces two files and restores them on success or failure:
- **Framework config** (`next.config.ts` / `astro.config.mjs`) — renamed to `clouduser.*`, replaced with CLI template, then restored.
- **`wrangler.json`** — replaced with CLI template (original saved to `clouduser.wrangler.json`), then restored. Do not modify `wrangler.json` during a deploy.

If Astro is the framework and `@astrojs/react` is absent, the CLI runs `npm install --save @astrojs/react` without prompting.

### Cloudflare bindings (D1 / KV / R2)

The CLI merges `wrangler.json` bindings at build time. Limits: **max 5 of each type**. For D1, set `migrations_dir` in the binding — the CLI copies migration files automatically.

### Error handling

- The CLI exits with **code 1 on every error**. Check the exit code — do not match on emoji or text patterns in stdout.
- Use `webflow log` after any failure to get the full error trace.

### Deploy versioning

| Situation | Version tag sent |
|---|---|
| Clean working tree | `git@{40-char-hash}` |
| Uncommitted changes | `git@{40-char-hash}+dirty` |
| Not in a git repo | `noversion@{ISO-timestamp}` |

Commit all changes before deploying to production.

### Known limitations

- No `cloud status` / `cloud logs` — use the Webflow dashboard.
- No `cloud env` commands — runtime env vars managed via dashboard only.
- No `--dry-run` — build validation always triggers a real deployment.
- No `--json` / structured output — deploy URL and project ID must be parsed from stdout.
- No `cloud rollback`.
- **100 MB build size limit** — builds exceeding 104,857,600 bytes fail at upload.
