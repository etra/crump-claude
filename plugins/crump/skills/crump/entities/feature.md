# feature

High-level deliverables that group related tasks — similar to epics

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `body` | string? |  |
| `id` | integer |  |
| `status` | `draft`, `in-progress`, `in-review`, `blocked`, `done`, `cancelled` |  |
| `title` | string |  |

## Relations

- has many `task`
- has many `comment`
- has many `document`

## Actions

### create

Create a new feature to group related tasks under a deliverable

```json
{"entity": "feature", "action": "create", "data": {"body": "...", "status": "...", "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | Detailed description, goals, or scope |
| `status` | string | no | Initial status (default: draft) |
| `title` | string | yes | Name of the feature or deliverable |

### get

Retrieve a feature and its details by ID

```json
{"entity": "feature", "action": "get", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

### list

List all features — use to see project roadmap and progress

```json
{"entity": "feature", "action": "list"}
```

### update

Update feature fields — title, description, or status

```json
{"entity": "feature", "action": "update", "data": {"body": "...", "id": 1, "status": "...", "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | New description or scope |
| `id` | integer | yes | ID of the feature to update |
| `status` | string | no | New status (draft, in-progress, done, cancelled) |
| `title` | string | no | New title |

### delete

Permanently remove a feature (does not delete its tasks)

```json
{"entity": "feature", "action": "delete", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

### add_task

Assign an existing task to this feature

```json
{"entity": "feature", "action": "add_task", "data": {"id": 1, "task_id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the parent entity (feature or component) |
| `task_id` | integer | yes | ID of the task to assign |

### add_document

Link a document to this feature as reference material

```json
{"entity": "feature", "action": "add_document", "data": {"document_id": 1, "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `document_id` | integer | yes | ID of the document to link or unlink |
| `id` | integer | yes | ID of the parent entity (task, feature, or component) |

### remove_document

Remove a document link from this feature

```json
{"entity": "feature", "action": "remove_document", "data": {"document_id": 1, "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `document_id` | integer | yes | ID of the document to link or unlink |
| `id` | integer | yes | ID of the parent entity (task, feature, or component) |

### list_documents

List all documents linked to this feature

```json
{"entity": "feature", "action": "list_documents", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

