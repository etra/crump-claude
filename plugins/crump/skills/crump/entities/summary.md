# summary

Final write-up after completing a task — captures what was done, key decisions, and outcomes

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `body` | string? |  |
| `id` | integer |  |
| `task_id` | integer |  |
| `title` | string |  |

## Relations

- has one `task`

## Actions

### save

Create or update the final summary for a completed task — captures outcomes and decisions

```json
{"entity": "summary", "action": "save", "data": {"body": "...", "task_id": 1, "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | Detailed write-up — what was done, key decisions, and outcomes |
| `task_id` | integer | yes | ID of the task this summary is for |
| `title` | string | yes | Brief headline of what was accomplished |

### get

Retrieve the summary for a task (returns null if no summary exists)

```json
{"entity": "summary", "action": "get", "data": {"task_id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `task_id` | integer | yes | ID of the task to query |

### delete

Remove a task's summary

```json
{"entity": "summary", "action": "delete", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

