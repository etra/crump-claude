# config

Top-level config — title, description, and global settings (singleton)

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer |  |
| `summary` | string? |  |
| `title` | string |  |

## Actions

### get

Get config

```json
{"entity": "config", "action": "get"}
```

### save

Update config

```json
{"entity": "config", "action": "save", "data": {"summary": "...", "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `summary` | string | no | High-level workspace description or overview |
| `title` | string | yes | Workspace name |

