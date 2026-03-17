# Plugin Structure

## Overview

The crump Claude Code plugin provides skills, agent prompts, and hooks that teach Claude how to interact with the crump CLI.

```
plugins/crump/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
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
- Response format with notifications
- Pipeline phases (refine, implement, review) and auto/manual modes
- Task lifecycle management (advance, reject, reset, block, cancel)
- Summary/PR mapping (summary → commit message, body → PR body)
- Conventions for task bodies, dependencies, documents, comments

### Entity references (entities/*.md)

Auto-generated from the Rust metadata registry using `cargo xtask generate-entities`. Each file documents:

- Entity description
- Fields with types
- Relations to other entities
- Available actions with input fields, required/optional markers, and JSON examples

**Do not edit these files manually** — they are overwritten on regeneration.

### Agent prompts

Stored in the workspace directory (`~/.crump/workspaces/{uuid}/`), not in the plugin. Each workspace gets:

- `crump-lead.md` — lead agent: plans features, creates tasks, monitors progress
- `crump-worker.md` — worker agent: implements code, signals completion

Local overrides can be placed in `.crump/` (project directory) — they take priority over workspace defaults.

### Hook (check-crump.sh)

A `PreToolUse` hook that runs before any Bash tool call. If the command starts with `crump`, it checks that the binary is installed and in `PATH`. If not, it blocks execution and shows install instructions.
