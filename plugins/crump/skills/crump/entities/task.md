# task

Individual work items — the smallest unit of work, like an issue or ticket

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `agent_id` | integer? |  |
| `body` | string? |  |
| `component_id` | integer? |  |
| `feature_id` | integer? |  |
| `id` | integer |  |
| `label` | string? |  |
| `status` | `backlog`, `refining`, `pending`, `todo`, `in-progress`, `in-review`, `blocked`, `done`, `cancelled` |  |
| `title` | string |  |

## Relations

- has one `feature`
- has one `component`
- has one `agent`
- has one `summary`
- has many `comment`
- has many `document`

## Actions

### create

Create a new task with title, optional body, status, and assignments

```json
{"entity": "task", "action": "create", "data": {"agent_id": 1, "body": "...", "component_id": 1, "feature_id": 1, "label": "...", "status": "...", "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `agent_id` | integer | no | Agent assigned to work on this task |
| `body` | string | no | Detailed description, requirements, or acceptance criteria |
| `component_id` | integer | no | Component this task affects |
| `feature_id` | integer | no | Feature this task belongs to |
| `label` | string | no | Classification label (e.g. bug, enhancement, chore) |
| `status` | string | no | Initial status (default: backlog) |
| `title` | string | yes | Short summary of what needs to be done |

### get

Retrieve a single task with all its fields by ID

```json
{"entity": "task", "action": "get", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

### list

List all tasks — use to find work items, check statuses, or pick next task

```json
{"entity": "task", "action": "list"}
```

### filter

Filter tasks by field values — AND between fields, OR for arrays on same field (e.g. status: ["todo", "in-progress"])

```json
{"entity": "task", "action": "filter", "data": {"agent_id": 1, "component_id": 1, "feature_id": 1, "label": "...", "status": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `agent_id` | integer | no | Filter by agent ID |
| `component_id` | integer | no | Filter by component ID |
| `feature_id` | integer | no | Filter by feature ID |
| `label` | string | no | Filter by label |
| `status` | string | no | Filter by status (string or array of strings, e.g. "todo" or ["todo", "in-progress"]) |

### update

Update task fields — commonly used to change status, title, body, or labels

```json
{"entity": "task", "action": "update", "data": {"agent_id": 1, "body": "...", "component_id": 1, "feature_id": 1, "id": 1, "label": "...", "status": "...", "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `agent_id` | integer | no | Reassign to a different agent |
| `body` | string | no | New body content |
| `component_id` | integer | no | Reassign to a different component |
| `feature_id` | integer | no | Reassign to a different feature |
| `id` | integer | yes | ID of the task to update |
| `label` | string | no | New classification label |
| `status` | string | no | New status (e.g. todo, in-progress, in-review, done, blocked, cancelled) |
| `title` | string | no | New title |

### delete

Permanently remove a task and its associations

```json
{"entity": "task", "action": "delete", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

### claim

Claim a task for an agent — sets agent_id and status to in-progress in one step

```json
{"entity": "task", "action": "claim", "data": {"agent_id": 1, "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `agent_id` | integer | yes | ID of the agent claiming this task |
| `id` | integer | yes | ID of the task to claim |

### set_component

Assign a task to a component — categorizes which part of the system it affects

```json
{"entity": "task", "action": "set_component", "data": {"component_id": 1, "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `component_id` | integer | yes | ID of the component to assign |
| `id` | integer | yes | ID of the task |

### set_feature

Assign a task to a feature — groups it under a high-level deliverable

```json
{"entity": "task", "action": "set_feature", "data": {"feature_id": 1, "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `feature_id` | integer | yes | ID of the feature to assign |
| `id` | integer | yes | ID of the task |

### add_document

Link a document to this task as reference material

```json
{"entity": "task", "action": "add_document", "data": {"document_id": 1, "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `document_id` | integer | yes | ID of the document to link or unlink |
| `id` | integer | yes | ID of the parent entity (task, feature, or component) |

### remove_document

Remove a document link from this task

```json
{"entity": "task", "action": "remove_document", "data": {"document_id": 1, "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `document_id` | integer | yes | ID of the document to link or unlink |
| `id` | integer | yes | ID of the parent entity (task, feature, or component) |

### list_documents

List all documents linked to this task

```json
{"entity": "task", "action": "list_documents", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

