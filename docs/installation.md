# Installation

## Prerequisites

- [Claude Code](https://claude.ai/code) — the AI coding agent
- [GitHub CLI](https://cli.github.com/) (`gh`) — authenticated (`gh auth login`)
- A GitHub repository with push access

## macOS / Linux

Run the installer:

```bash
curl -fsSL https://raw.githubusercontent.com/etra/crump-claude/main/install-crump.sh | bash
```

It will prompt you to pick a version, choose an install directory, and optionally install the Claude Code plugin.

## Windows

Download the binary from the [latest release](https://github.com/etra/crump-claude/releases):

| Platform | Path |
|----------|------|
| Windows x86_64 | `crump/windows-x86_64/crump.exe` |

Place `crump.exe` somewhere in your `PATH`.

Then install the Claude Code plugin:

```bash
claude plugin marketplace add https://github.com/etra/crump-claude
claude plugin install crump@crump-plugins
```

## Verify

```bash
crump --version
gh auth status
```

---

## Server Setup

### 1. Initialize a workspace

```bash
crump workspace init
```

The interactive wizard walks through:
- **Workspace name** — your project title
- **Storage** — SQLite (default, zero-config) or PostgreSQL *(coming soon)*
- **Transport** — Unix socket (default, fast, single-machine) or WebSocket *(coming soon)*
- **GitHub token** — for branch and PR operations via GitHub API
- **Pipeline** — which phases are auto vs manual

### 2. Add projects

```bash
crump workspace project
```

Fetches your GitHub repos via `gh` CLI. Select the ones you want to manage. Each project maps to a git repository.

### 3. Start the server

```bash
crump server start
```

Starts the transport listener and pipeline loop (ticks every 30s). Leave this running.

### 4. Generate a join token

```bash
crump workspace token
```

Copy the base64 token. Clients use it to connect.

---

## Client Setup

### 1. Join the workspace

```bash
cd ~/your-project   # must be a git checkout of a managed repo
crump workspace join
```

Paste the token from the server. Map server projects to local git directories.

### 2. Start the web dashboard

```bash
crump webserver
```

Opens at `http://localhost:8080`.

### 3. Start an interactive planning session

```bash
crump agent start
# Select: Interactive Agent
# Select: crump-lead
```

### 4. Start the worker loop

In a **separate terminal** with its own git checkout:

```bash
cd ~/agent-work/your-project
crump workspace join    # paste the same token
crump agent start
# Select: Loop Worker
# Select: crump-worker
```

---

## Parallel Workers

For faster execution, run multiple workers with separate git checkouts:

```
~/agent-work/
  instance-1/your-project/    # Worker 1
  instance-2/your-project/    # Worker 2
  instance-3/your-project/    # Worker 3
```

Each instance needs:
1. A full `git clone` of the repo
2. `crump workspace join` with the same token
3. `crump agent start` running

Tasks are assigned first-come-first-served. Workers skip tasks already in `implementing` state.

---

## Transport Options

### Unix Socket (default)

Fast, zero-config, single-machine. Uses `/tmp/crump.sock`.

Best for: local development, single machine with multiple terminals.

### WebSocket

*Documentation coming soon.*

Supports TLS, authentication tokens, and remote connections. Best for multi-machine setups.

### PostgreSQL

*Documentation coming soon.*

For teams and production deployments. Replaces SQLite.
