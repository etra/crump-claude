---
name: crump
description: Manage tasks using the crump CLI. Use when the user asks about tasks, wants to create/list/show tasks, manage features/components, change status, or get next work items.
allowed-tools: Bash(crump *)
user-invocable: true
argument-hint: "[command]"
---

# crump — create, read, update, and manage projects

$ARGUMENTS

Use this skill to interact with the crump project management system. Supports full CRUD on all entities.

## How to talk to crump

Pass JSON directly as an argument to `exec`:

```bash
crump exec '{"entity": "<entity>", "action": "<action>", "data": {...}}'
```

Response format:
```json
{"ok": true, "data": {...}}
{"ok": false, "error": "message"}
```

Multiline text — use `\n` for line breaks in `body` fields:
```bash
crump exec '{"entity": "task", "action": "create", "data": {"title": "Add auth", "body": "Requirements:\n\n- JWT tokens\n- Refresh flow\n\nAcceptance criteria:\n\n- Login returns token\n- Token validates on protected routes"}}'
```

Batch (sequential, stops on first error):
```bash
crump exec '[{"entity": "task", "action": "get", "data": {"id": 1}}, {"entity": "comment", "action": "create", "data": {"task_id": 1, "body": "Starting work"}}]'
```

## Entity reference

Before operating on an entity, read its reference doc for available actions, required fields, and JSON examples.

| Entity | Description | Reference |
|--------|-------------|:---------:|
| `task` | Individual work items — the smallest unit of work, like an issue or ticket | [entities/task.md](entities/task.md) |
| `feature` | High-level deliverables that group related tasks — similar to epics | [entities/feature.md](entities/feature.md) |
| `component` | Modules or subsystems of the project — used to categorize tasks by area (e.g. backend, auth, UI) | [entities/component.md](entities/component.md) |
| `agent` | AI coding agents that can be assigned to tasks — the workers that execute work items | [entities/agent.md](entities/agent.md) |
| `document` | Knowledge artifacts — specs, design docs, notes, or any reference material linkable to tasks, features, or components | [entities/document.md](entities/document.md) |
| `document_type` | Classification labels for documents — e.g. 'spec', 'design', 'runbook', 'adr' | [entities/document_type.md](entities/document_type.md) |
| `comment` | Threaded discussion on tasks and features — progress updates, questions, blockers, and decisions | [entities/comment.md](entities/comment.md) |
| `project` | Top-level project configuration — title, description, and global settings | [entities/project.md](entities/project.md) |
| `summary` | Final write-up after completing a task — captures what was done, key decisions, and outcomes | [entities/summary.md](entities/summary.md) |
