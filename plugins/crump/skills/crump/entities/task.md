# task

Individual work items — the smallest unit of work, like an issue or ticket

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `blocked` | boolean |  |
| `blocked_reason` | string? |  |
| `body` | string? |  |
| `component_id` | integer? |  |
| `depends_on` | array |  |
| `feature_id` | integer? |  |
| `id` | integer |  |
| `status` | any |  |
| `summary` | string? |  |
| `title` | string |  |

## Relations

- has one `feature`
- has one `component`
- has many `comment`
- has many `document`

## Actions

### draft

Create a task

```json
{"entity": "task", "action": "draft", "data": {"body": "...", "component_id": 1, "depends_on": "...", "feature_id": 1, "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | Detailed description, requirements, or acceptance criteria |
| `component_id` | integer | no | Component this task affects |
| `depends_on` | array | no | IDs of tasks that must complete before this one can start |
| `feature_id` | integer | no | Feature this task belongs to |
| `title` | string | yes | Short summary of what needs to be done |

### refine

Create a task and queue it for refinement

```json
{"entity": "task", "action": "refine", "data": {"body": "...", "component_id": 1, "depends_on": "...", "feature_id": 1, "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | Detailed description, requirements, or acceptance criteria |
| `component_id` | integer | no | Component this task affects |
| `depends_on` | array | no | IDs of tasks that must complete before this one can start |
| `feature_id` | integer | no | Feature this task belongs to |
| `title` | string | yes | Short summary of what needs to be done |

### implement

Create a task ready for implementation

```json
{"entity": "task", "action": "implement", "data": {"body": "...", "component_id": 1, "depends_on": "...", "feature_id": 1, "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | Detailed description, requirements, or acceptance criteria |
| `component_id` | integer | no | Component this task affects |
| `depends_on` | array | no | IDs of tasks that must complete before this one can start |
| `feature_id` | integer | no | Feature this task belongs to |
| `title` | string | yes | Short summary of what needs to be done |

### get

Get a task by ID

```json
{"entity": "task", "action": "get", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

### list

List all tasks

```json
{"entity": "task", "action": "list"}
```

### filter

Filter tasks by field values

```json
{"entity": "task", "action": "filter", "data": {"component_id": 1, "depends_on": 1, "feature_id": 1, "status": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `component_id` | integer | no | Filter by component ID |
| `depends_on` | integer | no | Filter by depends_on task ID |
| `feature_id` | integer | no | Filter by feature ID |
| `status` | string | no | Filter by status (string or array of strings, e.g. "todo" or ["todo", "in-progress"]) |

### update

Update task fields

```json
{"entity": "task", "action": "update", "data": {"body": "...", "component_id": 1, "depends_on": "...", "feature_id": 1, "id": 1, "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | New body content |
| `component_id` | integer | no | Reassign to a different component |
| `depends_on` | array | no | IDs of tasks that must complete before this one can start |
| `feature_id` | integer | no | Reassign to a different feature |
| `id` | integer | yes | ID of the task to update |
| `title` | string | no | New title |

### advance

Advance task to the next state

```json
{"entity": "task", "action": "advance", "data": {"force": "...", "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `force` | boolean | no | Force advance into an auto phase (skips the auto-phase guard) |
| `id` | integer | yes | ID of the entity |

### refined

Signal refinement complete

```json
{"entity": "task", "action": "refined", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |

### implemented

Signal implementation complete

```json
{"entity": "task", "action": "implemented", "data": {"id": 1, "summary": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |
| `summary` | string | yes | What was done — becomes the git commit message |

### reviewed

Signal review complete

```json
{"entity": "task", "action": "reviewed", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |

### block

Block a task (alias: stuck)

```json
{"entity": "task", "action": "block", "data": {"id": 1, "reason": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |
| `reason` | string | yes | Why it's blocked |

### unblock

Unblock a task (alias: unstuck)

```json
{"entity": "task", "action": "unblock", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |

### reject

Reject a task

```json
{"entity": "task", "action": "reject", "data": {"id": 1, "reason": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the task |
| `reason` | string | yes | What was wrong with the implementation |

### reset

Reset a task to draft

```json
{"entity": "task", "action": "reset", "data": {"id": 1, "reason": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |
| `reason` | string | no | Why it needs to start over |

### cancel

Cancel a task

```json
{"entity": "task", "action": "cancel", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |

### set_component

Assign task to a component

```json
{"entity": "task", "action": "set_component", "data": {"component_id": 1, "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `component_id` | integer | yes | ID of the component to assign |
| `id` | integer | yes | ID of the task |

### set_feature

Assign task to a feature

```json
{"entity": "task", "action": "set_feature", "data": {"feature_id": 1, "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `feature_id` | integer | yes | ID of the feature to assign |
| `id` | integer | yes | ID of the task |

### add_document

Link a document to this task

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

List documents linked to this task

```json
{"entity": "task", "action": "list_documents", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

