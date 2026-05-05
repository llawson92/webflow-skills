---
name: webflow-cli:cloud
description: Initialize, build, and deploy full-stack Webflow applications to Webflow Cloud hosting. Supports site-attached projects and apps (no site required). Use when creating new projects, deploying existing ones, or setting up CI/CD pipelines for Webflow Cloud.
---

# Webflow Cloud

Initialize new projects from templates and deploy to Webflow Cloud. Supports two modes: **site-attached** (connected to a Webflow site) and **app** (independent app, no site required).

## Instructions

### Step 0: Verify CLI is installed

```bash
webflow --version
```

If the command is not found, install it:

```bash
npm install -g @webflow/webflow-cli
# or yarn global add @webflow/webflow-cli
# or pnpm add -g @webflow/webflow-cli
```

Then proceed to state detection.

### Step 1: Detect project state

Run both checks before deciding which path to follow:

```bash
# Is this project already set up on Webflow Cloud?
cat webflow.json

# Is there a git remote?
git remote get-url origin 2>/dev/null
```

**Quick reference:**

| `cloud.project_id` in `webflow.json` | git remote | → Path |
|---|---|---|
| No | — | **A** — new project |
| Yes | No | **B** — existing project, no git |
| Yes | Yes | **C** — ideal state |

---

> **You are running without a TTY.** The CLI's interactive prompts only fire when `process.stdin.isTTY` is true. As an agent invoking the CLI through a subprocess, you do not have a TTY — every prompt is silently skipped, and any required value that wasn't passed as a flag triggers a hard error like `--project-name cannot be empty`.
>
> **Rule for every command in this skill:** pass all required flags explicitly. Never rely on prompts. Pass `--no-input` when the CLI accepts it to make this contract explicit. The required flag set per command:
>
> | Command | Always pass |
> |---|---|
> | `cloud init` (site-attached) | `--no-input --project-name <3–39 chars> --framework <astro\|nextjs> --mount <path> --site-id <id>` |
> | `cloud init --new` (app) | `--no-input --project-name <3–39 chars> --framework <astro\|nextjs>` |
> | `cloud deploy` | `--no-input --mount <path> --environment <env>` plus `--project-name` on first deploy |
>
> **One agent-fatal exception:** `cloud init --new` against a token that sees more than one workspace will **hang forever** — workspace selection is always interactive and has no `--workspace` flag and no non-TTY fallback. If you don't know whether the user's token is single- or multi-workspace, ask the user to run `cloud init --new` once locally; from there `cloud.workspace_id` is in `webflow.json` and you can take over.

---

### Path A: No `project_id` — new project

The project has not been deployed yet. Scaffold and deploy from scratch.

1. **Scaffold the project** — pick the form that matches the user's intent:

   ```bash
   # App (no site attachment) — single-workspace tokens only, see TTY note above
   webflow cloud init --new --no-input \
     --project-name my-app \
     --framework astro
   ```

   ```bash
   # Site-attached (connect to an existing Webflow site) — agent must already know --site-id
   webflow cloud init --no-input \
     --project-name my-app \
     --framework astro \
     --mount /app \
     --site-id site_abc123
   ```

   See [`cloud init`](#webflow-cloud-init) for all flags. If you don't have `--site-id` and the user wants site-attached, ask the user for the site ID before running anything.

2. **Deploy:**
   ```bash
   webflow cloud deploy \
     --no-input \
     --project-name my-app \
     --mount / \
     --environment main \
     --skip-mount-path-check \
     --skip-update-check
   ```
   This creates the project on Webflow Cloud and sets `cloud.project_id` in `webflow.json`. Commit the updated `webflow.json`.

3. **Set up git** (if not already):
   ```bash
   git init && git add . && git commit -m "init"
   git remote add origin https://github.com/your-org/my-app.git
   git push -u origin main
   ```
   From this point, every push to the connected branch triggers an automatic deploy.

> If a deploy auth error occurs: run `webflow auth login`, complete the browser flow, then retry step 2.

---

### Path B: `project_id` exists, no git remote — existing project, no git

The project is already on Webflow Cloud but has no git repo. Deploy directly and nudge toward git setup.

1. **Deploy:**
   ```bash
   webflow cloud deploy \
     --no-input \
     --mount / \
     --environment main \
     --skip-mount-path-check \
     --skip-update-check
   ```

2. **Nudge toward git:** suggest the user initializes a git repo and pushes to GitHub to unlock commit-push-deploy automation (see Path A, step 3).

> If a deploy auth error occurs: run `webflow auth login`, complete the browser flow, then retry step 1.

---

### Path C: `project_id` exists + git remote — ideal state

The project is deployed and connected. Confirm before suggesting anything.

> **Before making any suggestions:** ask the user whether the repo is already linked to Webflow Cloud. If it is, the only action needed is `git push`. Do not suggest re-linking or re-deploying.

1. **If already connected** — just commit and push:
   ```bash
   git add .
   git commit -m "your message"
   git push
   ```
   Webflow Cloud picks up the push and deploys automatically.

2. **If not yet connected** — run a manual deploy to complete the link:
   ```bash
   webflow cloud deploy \
     --no-input \
     --mount / \
     --environment main \
     --skip-mount-path-check \
     --skip-update-check
   ```
   After this deploy, commit-push-deploy is active.

> If a deploy auth error occurs: run `webflow auth login`, complete the browser flow, then retry.

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

The token written to `.env` depends on the init mode. Site-attached and app modes use **different env var names** — do not mix them up in CI.

**Site-attached init** writes:

| Variable | Description |
|---|---|
| `WEBFLOW_SITE_API_TOKEN` | OAuth access token. Required for deploy. Set by `webflow auth login` in site-attached mode. |
| `WEBFLOW_SITE_ID` | Set during `cloud init` (site-attached). |

**App init (`--new`)** writes:

| Variable | Description |
|---|---|
| `WEBFLOW_API_TOKEN` | Unified CLI access token. Required for deploy. Set by `webflow auth login` in app mode. **Not** the same env var as site-attached. |

After the **first app deploy**, the CLI provisions a site on the backend and additionally writes `WEBFLOW_SITE_ID` to `.env` automatically. From that point on the project behaves like a site-attached project for subsequent deploys.

Other env vars (any mode):

| Variable | Description |
|---|---|
| `DO_NOT_TRACK` | Set to `1` to opt out of telemetry. |
| `WEBFLOW_SKIP_UPDATE_CHECKS` | Set to `true` to skip the @webflow package update check. |

> **GitHub Secrets:** mirror the env vars the CLI wrote to `.env` — `WEBFLOW_SITE_API_TOKEN` (+ `WEBFLOW_SITE_ID`) for site-attached and post-first-deploy app projects, `WEBFLOW_API_TOKEN` for app projects that have not yet been deployed once. Never commit `.env` files.

### Configuration — webflow.json

```json
{
  "siteId": "site_abc123",
  "cloud": {
    "project_id": "proj_xyz",
    "environment_id": "env_xyz",
    "workspace_id": "ws_xyz",
    "framework": "nextjs",
    "skipMountPathCheck": false
  }
}
```

All `cloud.*` keys are **snake_case** (`project_id`, not `projectId`).

| Key | When set | Notes |
|---|---|---|
| `siteId` | Site-attached: at `cloud init`. App: after first deploy (CLI provisions a site). | Absent on app projects that have not been deployed yet. |
| `cloud.framework` | At `cloud init`. | Required for deploy resolution — see below. |
| `cloud.project_id` | After first deploy. | Auto-written. |
| `cloud.environment_id` | After first **app** deploy. | Auto-written by `createCloudApp`. |
| `cloud.workspace_id` | At app `cloud init` (`--new`). | Used by the first deploy to provision the site. |
| `cloud.skipMountPathCheck` | User-managed. | Equivalent to `--skip-mount-path-check`. |

The CLI also writes `cloud.deployment_type` (`"ssr" | "ssg" | "spa"`) and `cloud.entrypoint_path` into the **bundled** `webflow.json` at build time (these power the cosmic deployer's wrangler config). They're build-time outputs — do not strip them from the source `webflow.json` if you find them there; missing values silently break Next.js / Remix server-side deploys.

**`cloud.framework` resolution at deploy time:**

1. **`webflow.json` exists with `cloud.framework`** — used as-is. Invalid value exits with code 1.
2. **`webflow.json` exists but `cloud.framework` is absent** — throws: _"webflow.json exists but doesn't contain valid framework information under the 'cloud' key"_. Add `"cloud": { "framework": "nextjs" }` manually.
3. **No `webflow.json`** — auto-detected from `package.json`. CLI **writes a new `webflow.json`** on success.

Projects created via `cloud init` always land in case 1.

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
# Agent / non-TTY — always pass every flag
webflow cloud init \
  --no-input \
  --project-name my-app \
  --framework nextjs \
  --mount /app \
  --site-id site_abc123

# Human at a real terminal — interactive prompts will fill in any missing flag
webflow cloud init
```

Flags:

| Flag | Short | Description |
|---|---|---|
| `--project-name <name>` | `-n` | Project name. **Must be 3–39 characters** — the CLI rejects anything outside this range at init and at the first app deploy. |
| `--framework <framework>` | `-f` | Must match a scaffold ID from `cloud list`. Currently: `nextjs`, `astro`. |
| `--mount <path>` | `-m` | Mount path (default `/app` for site-attached, `/` for app). Substituted into config files at scaffold time. Not stored in `webflow.json`. |
| `--site-id <id>` | `-s` | Required in non-interactive site-attached mode. |
| `--new` | — | App mode (no site). |
| `--no-input` | — | CI mode. Requires `--project-name` and `--framework`. Without `--new`, defaults to app behavior. |

Credential resolution for `--no-input` site-attached: `--site-id` flag → `siteId` in `webflow.json` → `WEBFLOW_SITE_ID` env var → error.

After scaffolding a site-attached project, the CLI automatically runs a **DevLink sync**.

**App** (no site attachment):

```bash
# Agent / non-TTY — always pass every flag
webflow cloud init --new --no-input --project-name my-app --framework nextjs

# Human at a real terminal — prompts for workspace, framework, app name
webflow cloud init --new
```

> Even with `--no-input`, if the authenticated token sees **multiple workspaces** the CLI still tries to prompt for workspace selection (no `--workspace` flag exists), which hangs in non-TTY contexts. Ask the user to run `cloud init --new` once locally to seed `cloud.workspace_id` in `webflow.json`.

| | Site-attached | App (`--new`) |
|---|---|---|
| OAuth / site selection | Required at init | Skipped (workspace selection instead) |
| `WEBFLOW_SITE_ID` in `.env` | Written at init | Written **after first deploy** only |
| `WEBFLOW_SITE_API_TOKEN` in `.env` | Written | Not written |
| `WEBFLOW_API_TOKEN` in `.env` | Not written | Written |
| `cloud.workspace_id` in `webflow.json` | Not set | Set at init (used by first deploy) |
| Scaffold | `astro`, `nextjs` | `astro`, `nextjs` |
| Mount path | Configurable (default `/app`) | Always `/` |
| DevLink sync | Runs after init | Skipped |

**Workspace selection (app mode only):** after OAuth, the CLI calls `GET /v2/workspaces` to enumerate workspaces the token has access to. If there are multiple, it prompts the user to pick one; a single workspace is selected automatically. The choice is persisted as `cloud.workspace_id` in `webflow.json`. There is no `--workspace` flag — workspace is purely interactive at init time, and `--no-input` does **not** suppress it.

**Agent caveat:** if the user's token sees more than one workspace, the prompt fires unconditionally and hangs in non-TTY contexts. Mitigations, in order of preference: (a) ask the user to run `cloud init --new` once locally so `cloud.workspace_id` lands in `webflow.json`; (b) hand-write `webflow.json` with the workspace ID the user provides. To target a different workspace later, delete `cloud.workspace_id` and re-run init.

#### webflow cloud create (deprecated)

`webflow cloud create <name>` still works but **emits a deprecation warning** and will be removed in a future major release. It's hardcoded to `/app` mount in site-attached mode and offers a strict subset of `cloud init`. Always prefer `cloud init` (or `cloud init --new` for app mode).

#### webflow cloud deploy

**First app deploy provisions the Cloud app on the backend.** When `webflow.json` has no `siteId` but has `cloud.workspace_id` (the state left behind by `cloud init --new`), `cloud deploy` calls `POST /cosmic/workspaces/:workspace_id/cloudApps` to atomically create a site, project, and environment. On success it writes `siteId`, `cloud.project_id`, and `cloud.environment_id` back into `webflow.json` plus `WEBFLOW_SITE_ID` into `.env`, and forces `--skip-mount-path-check` for that one deploy. Subsequent deploys behave like a normal site-attached deploy.

If `--project-name` is omitted on the first app deploy, the CLI uses the **cwd folder name** (when 3–39 chars) and falls back to `"Cloud App"`. Provide `--project-name` explicitly in CI to avoid surprises.

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

> **Scaffolds are fetched from GitHub at init time.** The CLI downloads scaffold tarballs from `Webflow-Examples/hello-world-{astro,nextjs}*` (pinned to the `v1` branch). `cloud init` therefore requires network access to `github.com`. Old CLI installs keep working because the registry pins a `vN` branch per scaffold-contract version.

### Global flags

| Flag | Description |
|---|---|
| `--no-input` | Disable all interactive prompts. Required for CI/automation. |
| `--manifest <path>` | Custom path to `webflow.json`. Use for monorepos. |
| `--skip-update-check` | Skip @webflow package update check. Alternatively, set `WEBFLOW_SKIP_UPDATE_CHECKS=true`. |

## Output

After a successful `cloud deploy`, the CLI prints two pieces of output.

**1. Deployment dashboard URL** — always present on success:

```
https://webflow.com/dashboard/sites/{siteId}/webflow-cloud/projects/{projectId}/environments/{environmentId}/deployments/{deploymentId}
```

Always show this to the user. From here they can view build logs, deployment status, history, and environment settings.

**2. Live app URL** — conditional:

```
🌐 Your cloud app will soon be available at:
   https://{your-site}.webflow.io/{mount-path}
```

If a real URL is printed, show it to the user as the live app link. The domain is their Webflow site's domain and the path is whatever `--mount` value was used at deploy time (e.g. `/`, `/app`, or any other user-chosen path).

If the output instead reads `No domains found with the correct mount path configuration yet.`, do not show a live URL — point the user to the dashboard deployment link above to check status and configure their domain.

**Do not** fetch or curl either URL to verify the deploy — just return what the CLI printed.

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

### App workflow: init → first deploy provisions site

```bash
# Agent-safe init — assumes the token sees a single workspace.
# If the token sees multiple workspaces, ask the user to run this command locally first.
webflow cloud init --new --no-input \
  --project-name my-app \
  --framework astro

# First deploy creates site + project + environment on the backend,
# writes siteId / project_id / environment_id back to webflow.json,
# and writes WEBFLOW_SITE_ID to .env. Subsequent deploys are normal.
cd my-app
webflow cloud deploy --no-input \
  --project-name my-app \
  --mount / \
  --environment main \
  --skip-update-check
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

## Troubleshooting

### `--project-name cannot be empty` (or any required-flag error) on `cloud init`

The CLI gates its interactive prompts on `process.stdin.isTTY`. Agents invoke the CLI from a subprocess that does **not** have a TTY, so the prompt block is skipped entirely and the bare validation fires for the first missing required value.

**Fix:** pass every required flag explicitly. For `cloud init`:

```bash
webflow cloud init --new --no-input --project-name my-app --framework astro
# or, site-attached:
webflow cloud init --no-input --project-name my-app --framework astro --mount /app --site-id site_abc123
```

Passing `--no-input` is not strictly required for the prompts to be skipped — the absent TTY already does that — but it makes the contract explicit and matches the Required-flag matrix at the top of this skill.

### `cloud init --new` hangs forever / never returns

Workspace selection in app mode prompts unconditionally when the token sees more than one workspace, with no `--workspace` flag and no non-TTY fallback. In a non-TTY context the CLI hangs at the prompt.

**Fix:** ask the user to run `webflow cloud init --new` once locally to pick a workspace and seed `cloud.workspace_id` in `webflow.json`. After that, agents can run subsequent inits / deploys freely. Single-workspace tokens are not affected — selection is auto-skipped.

### Auth error on deploy

Run `webflow auth login` and complete the browser flow. The CLI writes a new `WEBFLOW_SITE_API_TOKEN` to `.env`. Retry the deploy after login.

In CI, browser auth is not possible — an auth error means `WEBFLOW_SITE_API_TOKEN` is missing or expired in your secrets. Fix the secret, do not attempt `webflow auth login`.

### Deploying to a different workspace

For **app projects (`--new`)**, workspace is fixed by `cloud.workspace_id` in `webflow.json` (chosen interactively at `cloud init`). To switch: delete `cloud.workspace_id` from `webflow.json` and re-run `webflow cloud init --new`. There is no `--workspace` flag.

For **site-attached projects**, workspace context is implicit in the auth token. Re-run `webflow auth login` and select the target workspace in the browser; the new token replaces the old one in `.env`.

### First app deploy fails with `missing_scopes`

The token saved to `.env` doesn't include the scopes needed to create a Cloud app. Re-run `webflow auth login` and re-approve the scopes, then retry the deploy.

### First app deploy fails: "your workspace has reached its app limit"

The selected workspace (`cloud.workspace_id`) is at its app cap. Either upgrade the workspace plan or delete unused apps in the Webflow dashboard, then retry.

### First app deploy fails with workspace-not-found / 404

The `cloud.workspace_id` in `webflow.json` no longer resolves (workspace deleted, or token has no access). Delete `cloud.workspace_id` from `webflow.json` and re-run `webflow cloud init --new` to pick a workspace the current token can see.

### `ENVIRONMENT_MOUNT_MISMATCH`

The `--mount` value does not match the path registered for that environment. Check the Webflow dashboard under the project's environment settings for the correct mount path and pass it explicitly.

### `webflow.json` exists but deploy fails on framework

If the error is _"webflow.json exists but doesn't contain valid framework information"_, add the `cloud` key manually:

```json
{
  "cloud": {
    "framework": "nextjs"
  }
}
```

Valid values: `nextjs`, `astro`, `remix`. Any other value exits with code 1.

### Build fails, need full trace

```bash
webflow log
```

Prints the path to the latest log file with the full error trace.
