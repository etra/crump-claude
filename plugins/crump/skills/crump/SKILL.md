---
name: crump
description: Manage tasks using the crump CLI. Use when the user asks about tasks, wants to create/list/get tasks, manage features/components, change status, or get next work items.
allowed-tools: Bash(crump *)
user-invocable: true
argument-hint: "[command]"
---

# crump — create, read, update, and manage projects

$ARGUMENTS

Use this skill to interact with the crump project management system. Supports full CRUD on all entities.

## How to talk to crump

All operations go through `crump exec` with JSON input:

```bash
crump exec '{"entity": "<entity>", "action": "<action>", "data": {...}}'
```

Response format:
```json
{"ok": true, "data": {...}}
{"ok": false, "error": "message"}
```

**Notifications:** Responses may include a `notifications` array — these are events from the pipeline loop or other sessions that happened since your last request. Your own actions are excluded.

```json
{"ok": true, "data": {...}, "notifications": [
  {"entity": "task", "entity_id": 1, "message": "Task #1 — implement → implementing"},
  {"entity": "task", "entity_id": 2, "message": "Task #2 BLOCKED: no summary"}
]}
```

When you receive notifications:
- **Transitions** (e.g. "Task #1 — implement → implementing") — the loop advanced a task. Update your understanding of project state.
- **Blocked** (e.g. "Task #2 BLOCKED: ...") — something failed. Investigate and help resolve (unblock, reject, or reset).
- **Empty array or missing** — nothing happened externally since your last request.

To list all recent notifications: `crump exec '{"entity":"notification","action":"list"}'`
To clean old notifications: `crump exec '{"entity":"notification","action":"clean"}'`

Multiline text — use `\n` for line breaks in `body` fields:
```bash
crump exec '{"entity": "task", "action": "draft", "data": {"title": "Add auth", "body": "Requirements:\n\n- JWT tokens\n- Refresh flow\n\nAcceptance criteria:\n\n- Login returns token\n- Token validates on protected routes"}}'
```

Batch (sequential, stops on first error):
```bash
crump exec '[{"entity": "task", "action": "get", "data": {"id": 1}}, {"entity": "comment", "action": "create", "data": {"task_id": 1, "body": "Starting work"}}]'
```

## Pipeline

Tasks and features move through a pipeline of phases. Each phase can be **auto** (handled by the loop) or **manual** (triggered by user/agent with `advance`).

### Task pipeline
```
draft → refine → refining → refined → implement → implementing → implemented → review → reviewing → reviewed → done
```

### Feature pipeline
```
draft → refine → refining → refined → implement → implementing → implemented → review → reviewing → reviewed → done
```

### Phase modes

- **auto** — the loop (`crump session start loop`) picks it up, spawns an agent, and advances on completion
- **manual** — the loop skips it; use `advance` action to progress

Which phases are auto vs manual is configured per project in `.crump/config.json` under `pipeline`. The planning prompt tells the agent which mode each phase is in.

### Phase descriptions

**Task phases:**
- **refine** — agent researches the codebase and writes requirements, implementation notes, and acceptance criteria
- **implement** — agent creates a git branch, writes code, adds tests, verifies the build
- **review** — agent opens a PR, reviews changes, approves or requests changes

**Feature phases:**
- **refine** — agent breaks the feature into implementable tasks with dependencies
- **implement** — creates feature branch, waits for all child tasks to complete, then agent validates combined code
- **review** — agent opens feature PR to main, reviews all changes

### Task lifecycle management

Tasks and features can be managed with these actions:

| Action | What it does |
|--------|-------------|
| `advance` | Move to the next state (checks exit/entry conditions) |
| `reject` | Send back to `implement` — code was wrong, redo implementation |
| `reset` | Send back to `draft` — requirements were wrong, start over |
| `block` | Flag as blocked with a reason. Loop will skip it. Alias: `stuck` |
| `unblock` | Clear the blocked flag. Alias: `unstuck` |
| `cancel` | Move to cancelled (terminal) |

**reject vs reset:**
- **`reject`** — the task requirements were fine but the implementation was bad. Sends back to `implement` so the agent retries with the same body. Summary is cleared. Use after reviewing code that doesn't meet acceptance criteria.
- **`reset`** — the task itself needs rethinking. Sends back to `draft` so you can rewrite the body, change scope, or restructure. Everything is cleared (summary, blocked state). Use when requirements were wrong, scope changed, or the approach needs a complete rethink.

**When to use each:**
- Code doesn't meet criteria → `reject` (same requirements, redo the work)
- Requirements were wrong or incomplete → `reset` (rewrite from scratch)
- Waiting on external dependency → `block` (with reason, unblock when resolved)
- Task is no longer needed → `cancel`

**Manual phases — what to do:**
- **Manual refining**: write the task body, then call `refined` or `advance` when done. The loop will NOT auto-advance — you control when refinement is complete.
- **Manual implementing**: write code, then call `implemented` with a summary. The loop will NOT auto-advance.
- **Manual reviewing**: the loop opens the PR automatically. Once the PR is merged on GitHub, the loop detects it and advances to `reviewed`. If the PR is closed without merging, the task gets blocked.

**Important: do NOT rush to complete states.** When working in an interactive session:
- Create tasks in `draft` — do NOT immediately advance them to `refined` or `implemented`
- Let the user review task bodies, plan dependencies, and confirm before moving forward
- Always ask the user before calling completion signals (`refined`, `implemented`, `reviewed`)
- Present the plan, get approval, then transition — one step at a time

**Summary and PR mapping:**
- Task `summary` → git commit message (written when signaling `implemented`)
- Task `body` → PR body (requirements and acceptance criteria for reviewers)
- Feature `summary` → git commit message on feature branch
- Feature `body` → feature PR body

## Conventions

These conventions apply to all agents. Follow them when creating or reading crump entities.

### Task body structure

Every task body should use this format so workers always know where to find what:

```
## Context
[Why this task exists. What feature it serves. What the current state is.]

## What to do
[Specific changes: files to create/modify, functions to add, endpoints to implement.
Be concrete — name the files, describe the data structures, reference existing patterns.]

## Implementation notes
[Suggested approach, patterns to follow, edge cases to handle.
Reference existing code: "Follow the pattern in src/handlers/users.rs"
Include relevant details from research.]

## Dependencies
[List task IDs that must be completed before this task can start.
e.g. "Depends on task #3 (database migration must exist first)"]

## Acceptance criteria
- [ ] [Concrete, testable condition]
- [ ] [Another concrete, testable condition]
- [ ] [Tests: what test cases are expected]
```

### Dependency ordering

Tasks and features have a `depends_on` field pointing to the ID of another task/feature that must complete first. Use it to express execution order:

- **Set `depends_on`** when creating or updating tasks/features that have prerequisites
- **In the task body** — include a "Dependencies" section explaining *why* the dependency exists (the field says *what*, the body says *why*)
- **In task order** — when presenting a plan, list tasks in execution order
- A task cannot enter implementation if its dependencies are not yet `done`
- A task under a feature cannot enter implementation until the feature has reached `implementing` (feature branch must exist). Advance the feature first

### Document types

Every project should have these standard document types (create them if they don't exist):

| Type | Purpose |
|------|---------|
| Architecture | System design and structure decisions |
| API | Endpoint contracts, schemas, protocols |
| Guide | How-to instructions for developers |
| ADR | Architecture Decision Record — individual design decisions with context and reasoning |
| Runbook | Operational procedures |

### Comment conventions

Comments are the audit trail. Use them for:
- **Research findings** — what you found when investigating code (files, patterns, gotchas)
- **Decisions** — what was decided and why (post on the feature)
- **Progress** — what was done, what's next (post on the task)
- **Blockers** — what's blocking and what's needed to unblock
- **Scope changes** — what changed and why

## Entity reference

Before operating on an entity, read its reference doc for available actions, required fields, and JSON examples.

| Entity | Description | Reference |
|--------|-------------|:---------:|
| `task` | Individual work items — the smallest unit of work, like an issue or ticket | [entities/task.md](entities/task.md) |
| `feature` | High-level deliverables that group related tasks — similar to epics | [entities/feature.md](entities/feature.md) |
| `component` | Modules or subsystems of the project — used to categorize tasks by area (e.g. backend, auth, UI) | [entities/component.md](entities/component.md) |
| `document` | Knowledge artifacts — specs, design docs, notes, or any reference material linkable to tasks, features, or components | [entities/document.md](entities/document.md) |
| `document_type` | Classification labels for documents — e.g. 'spec', 'design', 'runbook', 'adr' | [entities/document_type.md](entities/document_type.md) |
| `comment` | Threaded discussion on tasks and features — progress updates, questions, blockers, and decisions | [entities/comment.md](entities/comment.md) |
| `project` | Git repositories within the workspace | [entities/project.md](entities/project.md) |
| `config` | Top-level config — title, description, and global settings (singleton) | [entities/config.md](entities/config.md) |

