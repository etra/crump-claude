# Plugin Structure

## Overview

The crump Claude Code plugin provides skills, agent definitions, and hooks that teach Claude how to interact with crump.

```
plugins/crump/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── agents/
│   ├── crump-lead.md        # Lead agent prompt (planning)
│   └── crump-worker.md      # Worker agent prompt (execution)
├── hooks/
│   ├── hooks.json           # Hook configuration
│   └── check-crump.sh       # Validates crump is installed
└── skills/
    └── crump/
        ├── SKILL.md          # Main skill — JSON protocol, pipeline, conventions
        └── entities/         # Per-entity reference docs (auto-generated)
            ├── task.md
            ├── feature.md
            ├── component.md
            ├── document.md
            ├── document_type.md
            ├── comment.md
            ├── project.md
            └── config.md
```

## Components

### Skill (SKILL.md)

The main skill that Claude invokes when interacting with crump. It defines:

- The JSON protocol (`crump exec '{"entity": "...", "action": "...", "data": {...}}'`)
- Pipeline phases (refine, implement, review) and auto/manual modes
- Task lifecycle management (advance, move, block, unblock, reset, cancel)
- Completion signals (refined, implemented, reviewed) and what data each requires
- Conventions for task bodies, dependencies, documents, comments

### Entity references (entities/*.md)

Auto-generated from the Rust metadata registry using `cargo xtask generate-entities`. Each file documents:

- Entity description
- Fields with types
- Relations to other entities
- Available actions with input fields, required/optional markers, and JSON examples

**Do not edit these files manually** — they are overwritten on regeneration.

### Agent definitions

Built into the crump binary and served from the server:

| Agent | Permission Mode | Purpose |
|-------|----------------|---------|
| `crump-lead` | `acceptEdits` | Interactive planning — create features, tasks, write requirements |
| `crump-worker` | `bypassPermissions` | Automated execution — write code, run tests, signal completion |

Custom agents can be added via `crump agent add`.

### Hook (check-crump.sh)

A `PreToolUse` hook that runs before any Bash tool call. If the command starts with `crump`, it checks that the binary is installed and in `PATH`. If not, it blocks execution and shows install instructions.
