# How It Works

## Overview

crump is a pipeline-driven project management tool for AI coding agents. It separates planning from execution:

- **Planning**: you work with a lead agent in an interactive session to create features, tasks, and requirements
- **Execution**: a loop picks up tasks, spawns worker agents, handles git (branches, commits, PRs)
- **Communication**: both sessions share the same database. Notifications keep each side informed of changes.

## JSON protocol

All agent interaction goes through `crump exec`:

```bash
crump exec '{"entity": "task", "action": "draft", "data": {"title": "Add login"}}'
```

Response:
```json
{"ok": true, "data": {"id": 1, "title": "Add login", "status": "draft", ...}}
```

Responses include notifications from other sessions:
```json
{
  "ok": true,
  "data": {...},
  "notifications": [
    {"entity": "task", "entity_id": 2, "message": "Task #2 — implement → implementing"}
  ]
}
```

## Entities

| Entity | Purpose |
|--------|---------|
| **task** | Individual work items — what agents execute |
| **feature** | Groups related tasks into deliverables |
| **component** | Categorizes tasks by system area (e.g. backend, auth, UI) |
| **document** | Specs, design docs, reference material |
| **document_type** | Classification labels for documents |
| **comment** | Threaded discussion on tasks and features |
| **project** | Git repositories within the workspace |
| **config** | Top-level workspace config (title, summary) |
| **notification** | Pipeline events for cross-session awareness |

## Pipeline

### Task lifecycle

```
draft → refine → refining → refined → implement → implementing → implemented → review → reviewing → reviewed → done
```

Each phase has three states: **pending** (queued), **active** (work happening), **complete** (work done).

### Feature lifecycle

Same structure but with implementation meaning "all tasks are done":

```
draft → refine → refining → refined → implement → implementing → implemented → review → reviewing → reviewed → done
```

### State types

| Type | Examples | Behavior |
|------|----------|----------|
| **Pending** (gate) | draft, refine, implement, review | Auto-advance when conditions met |
| **Active** (phase) | refining, implementing, reviewing | Agent or user does work |
| **Complete** (gate) | refined, implemented, reviewed | Auto-advance |
| **Terminal** | done, cancelled | End state |

### Auto vs Manual phases

Each phase can be configured as:
- **Auto**: the loop spawns an agent, waits for completion, advances
- **Manual**: the loop skips it. You control when to advance.

For manual review: the loop still opens the PR and watches for merge. Once merged on GitHub, the loop advances automatically.

### State lifecycle

Every transition follows:
1. `check_exit(current)` — can we leave?
2. `check_entry(next)` — can we enter?
3. `on_enter(next)` — setup (create branch, open PR)
4. Status update
5. Execute (spawn agent if auto active state)
6. `on_exit` — validate (check summary, commit+push)

### Completion signals

Agents signal completion with specific actions:
- `refined` — refinement done (body written)
- `implemented` — implementation done (requires summary → becomes git commit message)
- `reviewed` — review done (crump merges the PR)

### Poke system

Every loop sweep "pokes" all tasks. Most states do nothing. But `reviewing` checks if the PR was merged externally and advances automatically.

## Git operations

crump handles all git through the `gh` CLI:

| When | What happens |
|------|-------------|
| Task enters `implementing` | Fetch, checkout task branch off feature branch |
| Agent signals `implemented` | Commit+push on task branch (summary = commit message) |
| Task enters `reviewing` | Open PR (task body = PR body) |
| PR merged on GitHub | Loop detects, advances to `reviewed` |
| Task enters `reviewed` | Delete local branch |
| Feature enters `implement` | Create+push feature branch |
| Feature enters `reviewing` | Commit+push, open feature PR |

Branch naming: `crump-{workspace_short}-f{feature_id}-t{task_id}` — unique per workspace.

## Session modes

| Mode | What it does |
|------|-------------|
| `planning` | Interactive session with lead agent. You plan features and tasks. |
| `once` | One sweep through all tasks/features, advance each by one step, exit. |
| `loop` | Continuous sweeps. Spawns agents for auto phases. Polls every N seconds. |

## Notifications

The loop writes notifications for state transitions and blocks. When an interactive session calls `crump exec`, it receives notifications from the loop since its last request. Self-actions are filtered out.

## Web dashboard

```bash
crump webserver
```

Shows pipeline view, tasks, features, sessions, audit log at `http://localhost:8080`.
