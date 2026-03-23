# Docker Deployment Guide

Run crump workers, Slack bots, and other agents in Docker containers for parallel execution.

## Prerequisites

- Docker and Docker Compose installed
- A running crump workspace (`crump workspace init` + `crump server start`)
- API keys and tokens (see below)

## Tokens You Need

### 1. Claude Code Authentication (required)

Docker containers share your Claude Code login via volume mount (`~/.claude`).

1. On your host machine (or Ubuntu server), run: `claude login`
2. It prints a URL — open it in any browser (can be a different machine)
3. Paste the authorization code back into the terminal
4. Docker Compose mounts `~/.claude` into containers as read-only at `/host-claude`
5. On startup, each container copies auth into its own isolated `CLAUDE_CONFIG_DIR`
   (e.g., `/root/.claude-worker-abc123`) — sessions and cache don't conflict between workers

**Ubuntu server setup:**
```bash
# Install Claude Code
npm install -g @anthropic-ai/claude-code

# Login (prints URL — open it in any browser, paste code back)
claude login

# Verify
claude --version
```

**Alternative:** If you prefer API key auth, set `ANTHROPIC_API_KEY` in your `.env` file.

### 2. Workspace Join Token (required)

This connects the Docker worker to your crump workspace.

```bash
# On the machine running the workspace server:
crump workspace join-token
```

Copy the output — it's a base64-encoded string containing the server address, port, auth token, and TLS certificate.

### 3. GitHub Token (recommended)

Workers need this to clone repos and create PRs.

1. Go to [github.com/settings/tokens](https://github.com/settings/tokens)
2. Create a **Fine-grained personal access token** or Classic token
3. Scopes needed: `repo` (full control of private repositories)
4. Save as `GH_TOKEN`

### 4. Slack Tokens (optional, for Slack bot)

If you want the Slack integration:

1. Go to [api.slack.com/apps](https://api.slack.com/apps) and create a new app
2. Enable **Socket Mode** (Settings → Socket Mode → Enable)
3. Create an **App-Level Token** with scope `connections:write` → save as `SLACK_APP_TOKEN`
4. Add **Bot Token Scopes** (OAuth & Permissions):
   - `chat:write` — post messages
   - `chat:write.customize` — custom bot name/icon
   - `app_mentions:read` — respond to @mentions
   - `channels:history` — read messages in channels
   - `channels:read` — list channels
5. **Subscribe to Events** (Event Subscriptions → Subscribe to bot events):
   - `message.channels` — messages in public channels
   - `app_mention` — @mentions of the bot
6. Install the app to your workspace
7. Copy the **Bot User OAuth Token** (`xoxb-...`) → save as `SLACK_BOT_TOKEN`
8. Get the **Channel ID**: right-click the channel in Slack → View channel details → scroll to bottom → copy ID → save as `SLACK_CHANNEL`

## Quick Start

### 1. Set up environment

```bash
cd /path/to/crump
cp .env.example .env
# Edit .env with your tokens
```

### 2. Build the image

```bash
docker compose build
```

### 3. Run a single worker

```bash
docker compose up worker
```

### 4. Scale to multiple workers

```bash
docker compose up --scale worker=3
```

### 5. Run specialized workers

```bash
# Implementation workers + review workers
docker compose --profile specialized up worker-implement worker-review
```

### 6. Run the Slack bot

```bash
docker compose --profile slack up slack
```

### 7. Run everything

```bash
docker compose --profile specialized --profile slack up --scale worker=2
```

## Configuration

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `ANTHROPIC_API_KEY` | No* | Claude API key (*or mount `~/.claude` — see auth section) |
| `CRUMP_JOIN_TOKEN` | Yes | Workspace join token |
| `GH_TOKEN` | Recommended | GitHub token for repo access |
| `CRUMP_PROJECTS` | Recommended | Comma-separated `name=url` pairs to clone |
| `CRUMP_AGENT` | No | Agent name (default: `crump-worker`) |
| `CRUMP_MODE` | No | Mode: `loop`, `once`, `slack` (default: `loop`) |
| `CRUMP_POLL` | No | Poll interval in seconds (default: `10`) |
| `CRUMP_FILTERS` | No | Extra flags: `--project x --stage implement` |
| `SLACK_BOT_TOKEN` | For Slack | Slack bot token (`xoxb-...`) |
| `SLACK_APP_TOKEN` | For Slack | Slack app token (`xapp-...`) |
| `SLACK_CHANNEL` | For Slack | Slack channel ID |

### Project Cloning

Projects are cloned at container startup. Format:

```
CRUMP_PROJECTS=crump=https://github.com/user/crump,frontend=https://github.com/user/frontend
```

Each `name=url` pair creates `/workspace/{name}` in the container. If the directory already exists (e.g., from a volume mount), it pulls latest instead.

### Work Filters

Use `CRUMP_FILTERS` to specialize workers:

```bash
# Only implement tasks for the "crump" project
CRUMP_FILTERS="--project crump --stage implement"

# Only review tasks
CRUMP_FILTERS="--stage review"

# Only work on a specific feature
CRUMP_FILTERS="--feature 5"
```

## Architecture

```
┌──────────────────────────────────────────────────┐
│  Your machine (workspace server)                 │
│                                                  │
│  crump workspace start                           │
│  ├── WebSocket API (wss://localhost:9090)        │
│  └── Web Dashboard (http://localhost:9091)       │
└──────────┬───────────────────────────────────────┘
           │ WebSocket (TLS)
           │
    ┌──────┴──────┐
    │   Docker    │
    │             │
    │  worker-1 ──┤──── claude agent (implements code)
    │  worker-2 ──┤──── claude agent (implements code)
    │  worker-3 ──┤──── claude agent (reviews PRs)
    │  slack    ──┤──── claude agent (Slack conversations)
    │             │
    └─────────────┘
```

Each container:
1. Clones git repos (using `GH_TOKEN`)
2. Joins the workspace (using `CRUMP_JOIN_TOKEN`)
3. Starts a crump session loop
4. Picks up tasks from the workspace
5. Spawns Claude Code to do the work
6. Commits, pushes, opens PRs

The workspace server coordinates — a task claimed by one worker won't be picked by another.

## Troubleshooting

### "Failed to connect to workspace"
- Is the workspace server running? (`crump workspace start`)
- Is the join token fresh? Regenerate with `crump workspace join-token`
- Is the server's TLS certificate valid for the Docker network? Add the Docker host IP during `crump workspace init` (TLS ingress step)

### "Permission denied" on git operations
- Check `GH_TOKEN` is set and has `repo` scope
- For SSH repos, mount your SSH keys: `-v ~/.ssh:/root/.ssh:ro`

### "Claude: command not found"
- The Dockerfile installs Claude Code via npm. Make sure the build completed successfully.
- Check: `docker compose run worker claude --version`

### Workers not picking up tasks
- Check the workspace has tasks in a ready state (`crump task list`)
- Check filters aren't too restrictive (`CRUMP_FILTERS`)
- Check the poll interval (`CRUMP_POLL`)

## Building from Source

If you want to build the crump binary from source instead of using the pre-built one:

```dockerfile
# Add to Dockerfile before the COPY line:
FROM rust:1.83-slim AS builder
WORKDIR /build
COPY crump/ ./
RUN cargo build --release
# Then replace the COPY line with:
COPY --from=builder /build/target/release/crump /usr/local/bin/crump
```
