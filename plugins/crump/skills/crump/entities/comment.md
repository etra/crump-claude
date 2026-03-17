# comment

Threaded discussion on tasks and features — progress updates, questions, blockers, and decisions

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `actor` | string? |  |
| `body` | string |  |
| `feature_id` | integer? |  |
| `id` | integer |  |
| `parent_id` | integer? |  |
| `task_id` | integer? |  |

## Relations

- has one `task`
- has one `feature`

## Actions

### create

Create a comment on a task or feature

```json
{"entity": "comment", "action": "create", "data": {"actor": "...", "body": "...", "feature_id": 1, "parent_id": 1, "task_id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `actor` | string | no | Who is commenting (e.g. "agent", "user", or agent name) |
| `body` | string | yes | Comment text — progress updates, questions, blockers, or decisions |
| `feature_id` | integer | no | ID of the feature this comment is about (provide task_id or feature_id) |
| `parent_id` | integer | no | Parent comment ID — for threaded replies |
| `task_id` | integer | no | ID of the task this comment is about (provide task_id or feature_id) |

### get

Get a comment by ID

```json
{"entity": "comment", "action": "get", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

### list

List comments for a task or feature

```json
{"entity": "comment", "action": "list", "data": {"feature_id": 1, "task_id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `feature_id` | integer | no | Filter comments by feature |
| `task_id` | integer | no | Filter comments by task |

### update

Update a comment

```json
{"entity": "comment", "action": "update", "data": {"actor": "...", "body": "...", "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `actor` | string | no | Updated actor |
| `body` | string | no | Updated comment text |
| `id` | integer | yes | ID of the comment to update |

### delete

Delete a comment

```json
{"entity": "comment", "action": "delete", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

