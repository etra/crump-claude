# How It Works

## Overview

crump uses a **server/client architecture**. The server owns the database, pipeline state machine, and git operations (via GitHub API). Clients connect via transport (Unix socket or WebSocket), execute agent work locally, and signal completion.

- **Server** — stores all data, runs the pipeline loop, manages branches and PRs via GitHub API
- **Interactive Agent** — you + lead agent plan features, create tasks, write requirements
- **Loop Agent** — automated worker that picks up tasks, spawns Claude to write code, signals completion
- **Web Dashboard** — read-only pipeline view
- **Slack Agent** — *(coming soon)* notifications and commands

## JSON protocol

All interaction goes through `crump exec`, which sends JSON-RPC to the server:

```bash
crump exec '{"entity": "task", "action": "draft", "data": {"title": "Add login"}}'
```

Response:
```json
{"ok": true, "data": {"id": 1, "title": "Add login", "status": "draft", ...}}
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
| **project** | Git repositories (name + origin as owner/repo) |
| **workspace** | Top-level config (title, summary) — singleton |

## Pipeline

### Task lifecycle

```
draft → refine → refining → refined → implement → implementing → implemented → review → reviewing → reviewed → done
```

### Feature lifecycle

Same phases, but implementation means "all tasks are done, validate the feature branch":

```
draft → refine → refining → refined → implement → implementing → implemented → review → reviewing → reviewed → done
```

### State types

| Type | Examples | Behavior |
|------|----------|----------|
| **Pending** | refine, implement, review | Waiting for agent pickup |
| **Active** | refining, implementing, reviewing | Agent is working |
| **Complete** | refined, implemented, reviewed | Work done, gate to next phase |
| **Terminal** | done, cancelled | End state |

### Who does what

| Transition | Responsibility |
|---|---|
| `draft` → `refine` | Server pipeline tick (automatic gate) |
| `refine` → `refining` | Agent loop (picks up, starts work) |
| `refining` → `refined` | Agent (signals completion) |
| `refined` → `implement` | Server pipeline tick (automatic gate) |
| `implement` → `implementing` | Agent loop (picks up, creates branch, starts work) |
| `implementing` → `implemented` | Agent (signals completion with summary) |
| `implemented` → `review` | Server pipeline tick (automatic gate) |
| `review` → `reviewing` | Agent loop (picks up, opens PR) |
| `reviewing` → `reviewed` | Server (detects PR merge via GitHub API) |
| `reviewed` → `done` | Server pipeline tick (merges PR, cleans up branch) |

**Key principle**: the server pipeline tick only advances **gate transitions** (complete→next pending). It never advances pending→active — that's exclusively the agent loop's job.

### Auto vs Manual phases

Each phase can be configured as:
- **Auto**: the loop agent picks it up, spawns Claude, waits for completion
- **Manual**: the loop skips it — you control when to advance

Default configuration: implementation and review are auto. Refinement is manual.

### Completion signals

Agents signal completion with specific actions:
- `refined` — refinement done (task body must be written first)
- `implemented` — implementation done (requires `summary` — becomes the git commit message)
- `reviewed` — review done (server merges the PR)

If the agent can't complete, it signals `block` with a reason.

### Dependencies

Tasks and features support `depends_on` for ordering:
- Dependencies don't block state transitions — a task can move to `implement` even if deps aren't met
- Dependencies block **agent pickup** — a task won't be handed to a worker until all deps are terminal (done/cancelled)

## Git operations

The **server** handles all git operations via GitHub API (no local git on the server):

| When | What happens |
|------|-------------|
| Task enters `implement` | Server creates task branch via GitHub API |
| Agent finishes implementing | Client commits + pushes to task branch |
| Task enters `review` | Server opens PR (task branch → feature branch or main) |
| Task enters `reviewed` | Server merges the PR via GitHub API |
| Task enters `done` | Server deletes the task branch |
| Feature enters `implement` | Server creates feature branch |
| Feature enters `review` | Server opens feature PR (feature branch → main) |
| Feature enters `reviewed` | Server merges the feature PR |

### Branch naming

```
main
  └── crump-{uid}-f{feature_id}              # feature branch
        ├── crump-{uid}-f{fid}-t{task_id_1}  # task branch
        └── crump-{uid}-f{fid}-t{task_id_2}  # task branch
```

Standalone tasks (no feature) branch directly from main: `crump-{uid}-t{task_id}`

The `{uid}` is the first 8 characters of the server's workspace UUID — ensures branch names are unique per workspace.

### PR flow

- **Task PRs** merge into the feature branch (or main if standalone)
- **Feature PRs** merge into main
- This keeps main clean until the entire feature is validated

## Agent prompts

When the agent loop picks up a task, it:

1. Advances the task from pending → active (e.g. `implement` → `implementing`)
2. Fetches a context-rich prompt from the server via `task prompt`
3. Spawns Claude with the prompt

The prompt includes:
- Task title, body (requirements/acceptance criteria)
- Feature context (title, description)
- Component context (name, prefix)
- Dependencies (with their statuses)
- Linked documents
- Branch name
- Phase-specific instructions (what to do)
- Completion command (how to signal done, what data is required)
- Blocked command (how to signal stuck)

## Notifications

Mutations broadcast in-memory notifications to all connected clients via the transport layer (60s TTL). Interactive agents see what the loop is doing, and vice versa.

## Auto-reconnect

All clients (web dashboard, agent loop, interactive agent) automatically reconnect if the server restarts — exponential backoff, up to 5 retries (1s, 2s, 4s, 8s, 16s).

## Web dashboard

```bash
crump webserver
```

Opens at `http://localhost:8080`. Shows:
- Pipeline view with state counts
- Features and tasks with statuses
- Components and projects
- Sessions and agents
- Audit log
