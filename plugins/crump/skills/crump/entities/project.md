# project

Top-level project configuration — title, description, and global settings

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer |  |
| `summary` | string? |  |
| `title` | string |  |

## Actions

### get

Retrieve project configuration — title, description, and settings

```json
{"entity": "project", "action": "get"}
```

### save

Update project configuration

```json
{"entity": "project", "action": "save", "data": {"summary": "...", "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `summary` | string | no | High-level project description or overview |
| `title` | string | yes | Project name |

