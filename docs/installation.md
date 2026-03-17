# Installation

## Prerequisites

- [Claude Code](https://claude.ai/code) — the AI coding agent
- [Git](https://git-scm.com/) — version control
- [GitHub CLI](https://cli.github.com/) (`gh`) — crump uses it for PR creation, merging, and state checks. Must be authenticated (`gh auth login`).

## macOS / Linux

Run the installer — it will prompt you to pick a version, choose an install directory, and optionally install the Claude Code plugin:

```bash
curl -fsSL https://raw.githubusercontent.com/etra/crump-claude/main/install-crump.sh | bash
```

Example session:

```
Detected: Darwin (arm64)

Fetching available versions...
Available versions:
  1) v0.0.3 (latest)
  2) v0.0.2

Pick a version number [1 for v0.0.3]: 1
Selected version: v0.0.3

Install directory [/Users/you/.local/bin]:

Downloading crump v0.0.3...
Installed crump to /Users/you/.local/bin/crump
Version: crump 0.0.3

Install Claude Code plugin now? [Y/n]: Y

Adding marketplace...
Installing plugin...

Done! Plugin installed.
```

## Windows

Download the binary manually from the [latest release](https://github.com/etra/crump-claude/releases) or from the repo:

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

## Initialize a workspace

```bash
cd your-project
crump workspace init "My Project"
```

This creates:
- `~/.crump/workspaces/{uuid}/` — central config, database, agent prompts
- `.crump/config.json` — local pointer file

## Set up two directories

For the full workflow (planning + execution), set up two copies of your repo:

```bash
# Terminal 1: Lead agent (planning)
cd ~/work/my-project
crump workspace init "My Project"

# Terminal 2: Worker agent (loop)
cd ~/work
git clone <your-repo-url> my-project-worker
cd my-project-worker
crump workspace attach
# Select the workspace you just created
```

Both directories share the same database. The lead plans tasks, the worker executes them.

## Start

```bash
# Terminal 1: Interactive planning
crump start planning --agent crump-lead

# Terminal 2: Automated execution
crump start loop --agent crump-worker --poll 10
```

The loop will prompt for permission mode and tools. For non-interactive agents, select `bypassPermissions`.
