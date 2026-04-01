---
name: webflow-cli:cloud
description: Initialize, build, and deploy full-stack Webflow applications to Webflow Cloud hosting. Supports site-attached projects and standalone apps (no site required). Use when creating new projects, deploying existing ones, or setting up CI/CD pipelines for Webflow Cloud.
---

# Webflow Cloud

Initialize new projects from templates and deploy to Webflow Cloud. Supports two modes: **site-attached** (connected to a Webflow site) and **standalone** (independent app, no site required).

## Tool usage

- Use the **Bash tool** for all `webflow cloud` commands
- Use the **Read tool** to examine `webflow.json`, `package.json` — never modify these directly
- Use the **Glob tool** to discover project files
- **Do not** use Webflow MCP tools for CLI workflows

## Global flags

These flags work on every `webflow` command:

| Flag | Description |
|---|---|
| `--no-input` | Disable all interactive prompts. Required for CI/automation. |
| `--manifest <path>` | Custom path to `webflow.json`. Use for monorepos with multiple sub-projects. |
| `--skip-update-check` | Skip @webflow package update check. Optional — in non-TTY or `--no-input` mode the check already skips interactive prompts and only prints update suggestions. Use it to suppress that output or avoid the network round-trip. Alternatively, set `WEBFLOW_SKIP_UPDATE_CHECKS=true`. |

## Authentication

```bash
# Interactive login (local dev)
webflow auth login
```

Environment variables read by the CLI:

| Variable | Required | Description |
|---|---|---|
| `WEBFLOW_SITE_API_TOKEN` | Yes (for deploy) | OAuth access token. Written to `.env` after `webflow auth login`. |
| `WEBFLOW_SITE_ID` | Site-attached only | Written to `.env` during `cloud init`. Absent for standalone apps. |
| `DO_NOT_TRACK` | No | Set to `1` to opt out of telemetry. |

> **Note:** The CLI uses `WEBFLOW_SITE_API_TOKEN` (not `WEBFLOW_API_TOKEN`). Use `WEBFLOW_SITE_API_TOKEN` in GitHub Secrets.

Never commit `.env` files. Use CI/CD secrets for production credentials.

## Configuration — webflow.json

The CLI reads and writes `webflow.json` in the project root.

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
- `siteId` is absent for standalone apps.
- The CLI does **not** auto-read a mount path from `webflow.json` at deploy time. `--mount` must always be passed explicitly to `cloud deploy`, or provided interactively. There is no manifest field that substitutes for it.
- `cloud.framework` resolution at deploy time follows three-state logic:
  1. **`webflow.json` exists with `cloud.framework`** — used as-is. Validated against the supported list; any unsupported value exits with code 1.
  2. **`webflow.json` exists but `cloud.framework` is absent** — throws immediately: _"webflow.json exists but doesn't contain valid framework information under the 'cloud' key"_. Add `"cloud": { "framework": "nextjs" }` (or `"astro"`) manually.
  3. **No `webflow.json`** — auto-detected from `package.json` dependencies (both `dependencies` and `devDependencies`). On success the CLI **writes a new `webflow.json`** with the detected framework as a side effect. On failure, exits with code 1.
- Projects created via `cloud init` always land in case 1 — `cloud.framework` is written automatically.

## Commands

### webflow cloud list

List available scaffold templates.

```bash
webflow cloud list
```

### webflow cloud init

Bootstrap a new project. Two modes: **site-attached** and **standalone**.

#### Site-attached (connects to an existing Webflow site)

```bash
# Interactive (local dev)
webflow cloud init

# Non-interactive (local one-time setup only — NOT for CI pipelines)
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
| `--project-name <name>` | `-n` | Project name. Prompted if omitted in TTY mode. |
| `--framework <framework>` | `-f` | Must match a scaffold ID from `webflow cloud list`. Currently: `nextjs`, `astro`, `nextjs-minimal`, `astro-minimal`. Any other value exits with code 1 — `cloud init` validates against the scaffold registry, not the deploy-time framework list. |
| `--mount <path>` | `-m` | Mount path (default: `/app` for site-attached, `/` for standalone). Substituted into framework config files (`next.config.ts`, `astro.config.mjs`) at scaffold creation time. **Not stored in `webflow.json`** — must be passed explicitly to `cloud deploy` every time. |
| `--site-id <id>` | `-s` | **Required in non-interactive existing mode.** Without it the CLI errors: _"--site-id is required when connecting to an existing site in non-interactive mode."_ |
| `--new` | — | Standalone mode. See below. |
| `--no-input` | — | CI mode. Requires `--project-name` and `--framework`. **If `--new` is not passed and the mode cannot be determined interactively, `--no-input` defaults to standalone (`--new`) behavior.** Pass `--new` explicitly to make intent clear. |

> **`cloud init` is for local, one-time project setup — never run it in CI.** Existing mode opens a browser window; there is no headless OAuth path. Standalone mode skips OAuth but still fetches scaffold files from `github.com/Webflow-Examples/hello-world-{framework}` and produces a project directory that must be committed — neither belongs in a deployment pipeline. Run `cloud init` once locally, commit the result, then use `cloud deploy` in CI from that point on.

**Credential resolution order for site-attached `--no-input`:** `--site-id` flag → `siteId` in `webflow.json` → `WEBFLOW_SITE_ID` env var → error. `WEBFLOW_SITE_API_TOKEN` must also be present in the environment.

After scaffolding a site-attached project, the CLI automatically runs a **DevLink sync** to pull component types into the project. No extra step needed.

#### Standalone (no site attachment)

Use `--new` to create an app that is not connected to any Webflow site.

```bash
# Interactive (local dev)
webflow cloud init --new

# Non-interactive (local one-time setup only — NOT for CI pipelines)
# Run this once locally to scaffold the project, then commit the result.
# CI should only ever run `cloud deploy`, never `cloud init`.
webflow cloud init --new --no-input --project-name my-app --framework nextjs
```

Differences from site-attached:

| | Site-attached | Standalone (`--new`) |
|---|---|---|
| OAuth / site selection | Required at init | Skipped at init — no deferred CLI auth at deploy time either. Set `WEBFLOW_SITE_API_TOKEN` as an env var before deploying. |
| `WEBFLOW_SITE_ID` in `.env` | Written | Not written |
| `WEBFLOW_SITE_API_TOKEN` in `.env` | Written | Not written |
| Scaffold | Full (`astro`, `nextjs`) | Minimal (`astro-minimal`, `nextjs-minimal`) |
| Mount path | Configurable (default `/app`) | Always `/` |
| DevLink sync | Runs after init | Skipped |
| `siteId` in `webflow.json` | Written | Absent |

### webflow cloud create \<name\> (legacy)

This command exists but is limited — it sets `mount=/app` with no standalone support. **Prefer `cloud init` in all cases.**

### webflow cloud deploy

Build and deploy to Webflow Cloud. Reads config from `webflow.json` and `.env`.

```bash
# Standard non-interactive deploy
webflow cloud deploy \
  --no-input \
  --mount /app \
  --environment production \
  --skip-mount-path-check \
  --skip-update-check
```

All flags:

| Flag | Short | Description |
|---|---|---|
| `--no-input` | — | CI mode. Disables all prompts. |
| `--mount <path>` | `-m` | Mount path. **Always required with `--no-input`.** Not auto-read from `webflow.json`. Must match the existing environment's registered mount path or `ENVIRONMENT_MOUNT_MISMATCH` will occur. |
| `--environment <env>` | `-e` | Environment name. Creates if it does not exist. **Must be passed together with `--mount`** — providing one without the other drops into the interactive flow, which fails under `--no-input`. |
| `--project-name <name>` | `-n` | **Required on first deploy when using `--no-input` and no `cloud.project_id` exists in `webflow.json`.** Without it the CLI has no name for the new project and will exit with code 1. |
| `--directory <path>` | `-d` | Project directory (default: cwd). Use for monorepos. |
| `--description <text>` | — | Project description for the first deploy. |
| `--skip-mount-path-check` | — | Skip domain manifest validation. Required in CI. Can also be persisted in `webflow.json` as `cloud.skipMountPathCheck: true` to avoid passing the flag on every deploy. |
| `--auto-publish` | — | Publish the Webflow **site** to sync mount path routing on custom domains. Does not affect app deployment — the app is always deployed immediately. |
| `--skip-update-check` | — | Skip @webflow package update check. Optional — see global flags. |

#### Determining the mount path

`--mount` is **always required** when using `--no-input`. The CLI does not read a saved mount path from `webflow.json` — it must be passed every time.

- **Never assume a default.** Mount path varies per project. Assuming `/app` WILL cause `ENVIRONMENT_MOUNT_MISMATCH` errors if the project uses a different path.
- Check with the project owner or look for the mount path in the Webflow dashboard under the project's environment settings.
- Once you know the correct value, pass it explicitly on every non-interactive deploy.

## Frameworks

A framework list exists:

- **Init scaffolds** (`cloud init --framework`): validated against the scaffold registry (`cloud list`). Currently `nextjs`, `astro`, `nextjs-minimal`, `astro-minimal`. All other values are rejected here.
- **Deploy detection** (`cloud deploy`): validated against `["nextjs", "astro", "remix"]`. This is what governs `cloud.framework` in `webflow.json` and auto-detection from `package.json`.

| Framework | Init scaffold | Deploy support | Detected via package |
|---|---|---|---|
| `nextjs` | ✓ | ✓ | `@opennextjs/cloudflare` |
| `nextjs-minimal` | ✓ (standalone) | — | — |
| `astro` | ✓ | ✓ | `@astrojs/cloudflare` |
| `astro-minimal` | ✓ (standalone) | — | — |
| `remix` | — (existing projects only) | ✓ | `@remix-run/cloudflare` |

> **Other frameworks:** Are blocked at deploy time. Passing any of these in `cloud.framework` exits with code 1. These are not yet supported — do not suggest them to users.

## Package manager detection

The CLI uses **npm only**, regardless of what lock files are present.

- `package-lock.json` found → `npm ci`
- No `package-lock.json` → `npm install`

pnpm and yarn lock files are not detected or acted on. Projects using pnpm or yarn will silently receive `npm install` during `cloud deploy`.

## Build-time file management

During `cloud deploy`, the CLI temporarily replaces two project files and restores them afterward — restoration runs on both success and failure:

- **Framework config** (`next.config.ts` or `astro.config.mjs`) is renamed to `clouduser.next.config.ts` / `clouduser.astro.config.mjs`, replaced with the CLI's own template, then renamed back.
- **`wrangler.json`** is replaced with the CLI's internal template (your original, if any, is saved to `clouduser.wrangler.json`), then restored. If you had no `wrangler.json`, the CLI's template is left in place for future deploys.

> If Astro is the framework and `@astrojs/react` is not in `package.json`, the CLI runs `npm install --save @astrojs/react` before building. This modifies your `package.json` and `node_modules` without prompting.

## Cloudflare bindings (D1 / KV / R2)

If the project has a `wrangler.json`, the CLI merges bindings into its Cloudflare deployment template at build time. Limits: **max 5 of each type** (KV namespaces, D1 databases, R2 buckets).

The CLI backs up `wrangler.json` to `clouduser.wrangler.json` before building and restores it afterward. Do not modify `wrangler.json` during a deploy.

For D1, set `migrations_dir` in the binding — the CLI copies migration files automatically.

## Error handling

The CLI exits with **code 1 on every error**. Check the exit code — do not match on emoji or text patterns in stdout, which can change between versions.

`webflow log` is a built-in CLI command that prints the path to the latest log file. Use it after any failure to get the full error trace.

```bash
webflow cloud deploy --no-input --mount /app --skip-mount-path-check --skip-update-check
if [ $? -ne 0 ]; then
  echo "Deploy failed. Log file:"
  webflow log
  exit 1
fi
```

In GitHub Actions, failures are detected automatically via exit code. No stdout parsing needed.

## Agent and CI automation notes

**Do not add a human confirmation gate before `cloud deploy --no-input`.**

When `--no-input` is set, the CLI skips all interactive steps — there is no built-in confirmation prompt. An agent adding its own "type 'deploy' to confirm" step is unnecessary overhead and will block unattended CI runs.

Correct CI pattern:

```bash
# Validate required env vars are present, then deploy directly
if [ -z "$WEBFLOW_SITE_API_TOKEN" ]; then
  echo "Missing WEBFLOW_SITE_API_TOKEN" && exit 1
fi
webflow cloud deploy --no-input --mount /app --skip-mount-path-check --skip-update-check
```

## GitHub Actions example

GitHub Actions is the primary deployment path for production. Local `cloud deploy` is for development and testing.

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
            --mount /app \
            --environment production \
            --skip-mount-path-check \
            --skip-update-check
        env:
          WEBFLOW_SITE_API_TOKEN: ${{ secrets.WEBFLOW_SITE_API_TOKEN }}
          WEBFLOW_SITE_ID: ${{ secrets.WEBFLOW_SITE_ID }}
          # For standalone apps, omit WEBFLOW_SITE_ID
```

## Deploy versioning

Every deployment sends a version string to the API derived from git state:

| Situation | Version tag sent |
|---|---|
| Clean working tree | `git@{40-char-hash}` |
| Uncommitted changes present | `git@{40-char-hash}+dirty` |
| Not in a git repo | `noversion@{ISO-timestamp}` |

Deploying with uncommitted changes sends the `+dirty` tag. The server records this against the deployment. Commit all changes before deploying to production.

## Telemetry

Telemetry is opt-out. To disable: set `DO_NOT_TRACK=1`.

## Known limitations

These features require the Webflow dashboard — no CLI support yet:

- No `cloud status` or `cloud logs` commands — deployment status and build log streaming require dashboard.
- No `cloud env` commands — runtime environment variables managed via dashboard only.
- No `--dry-run` on deploy — build validation always triggers a real deployment.
- No `--json` / structured output on any command — deploy URL and project ID must be read from human-readable stdout.
- No `cloud rollback` command.
- **100 MB build size limit** — the CLI enforces a hard cap of 104,857,600 bytes on the tarball uploaded at deploy time. Builds exceeding this fail at the upload step with an explicit error. Reduce bundle size or split into multiple projects if you hit this.
