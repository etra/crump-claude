# feature

High-level deliverables that group related tasks — similar to epics

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `blocked` | boolean |  |
| `blocked_reason` | string? |  |
| `body` | string? |  |
| `depends_on` | array |  |
| `id` | integer |  |
| `project_id` | integer? | Project (git repo) this feature belongs to |
| `status` | any |  |
| `summary` | string? | Post-validation summary — captures what was validated and any issues found |
| `title` | string |  |

## Relations

- has many `task`
- has many `comment`
- has many `document`
- has one `project`

## Actions

### draft

Create a feature

```json
{"entity": "feature", "action": "draft", "data": {"body": "...", "depends_on": "...", "project_id": 1, "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | Detailed description, goals, or scope |
| `depends_on` | array | no | IDs of features that must complete before this one can start |
| `project_id` | integer | no | Project (git repo) this feature belongs to |
| `title` | string | yes | Name of the feature or deliverable |

### refine

Create a feature and queue it for refinement

```json
{"entity": "feature", "action": "refine", "data": {"body": "...", "depends_on": "...", "project_id": 1, "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | Detailed description, goals, or scope |
| `depends_on` | array | no | IDs of features that must complete before this one can start |
| `project_id` | integer | no | Project (git repo) this feature belongs to |
| `title` | string | yes | Name of the feature or deliverable |

### get

Get a feature by ID

```json
{"entity": "feature", "action": "get", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

### list

List all features

```json
{"entity": "feature", "action": "list"}
```

### filter

Filter features by field values

```json
{"entity": "feature", "action": "filter", "data": {"depends_on": 1, "status": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `depends_on` | integer | no | Filter by depends_on feature ID |
| `status` | string | no | Filter by status (string or array of strings, e.g. "draft" or ["draft", "in-progress"]) |

### update

Update feature fields

```json
{"entity": "feature", "action": "update", "data": {"body": "...", "depends_on": "...", "id": 1, "project_id": 1, "summary": "...", "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | New description or scope |
| `depends_on` | array | no | IDs of features that must complete before this one can start |
| `id` | integer | yes | ID of the feature to update |
| `project_id` | integer | no | Project (git repo) this feature belongs to |
| `summary` | string | no | Post-validation summary |
| `title` | string | no | New title |

### advance

Advance feature to the next state

```json
{"entity": "feature", "action": "advance", "data": {"force": "...", "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `force` | boolean | no | Force advance into an auto phase (skips the auto-phase guard) |
| `id` | integer | yes | ID of the entity |

### move

Move feature to any state (forward or backward)

```json
{"entity": "feature", "action": "move", "data": {"id": 1, "target": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |
| `target` | string | yes | Target state (e.g. "draft", "implement", "review", "done") |

### refined

Signal refinement complete

```json
{"entity": "feature", "action": "refined", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |

### implemented

Signal implementation complete

```json
{"entity": "feature", "action": "implemented", "data": {"id": 1, "summary": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |
| `summary` | string | yes | What was done — becomes the git commit message |

### reviewed

Signal review complete

```json
{"entity": "feature", "action": "reviewed", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |

### block

Block a feature (alias: stuck)

```json
{"entity": "feature", "action": "block", "data": {"id": 1, "reason": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |
| `reason` | string | yes | Why it's blocked |

### unblock

Unblock a feature (alias: unstuck)

```json
{"entity": "feature", "action": "unblock", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |

### reset

Reset feature to a previous state. Pass reset_to for target state, or omit to go back one step

```json
{"entity": "feature", "action": "reset", "data": {"id": 1, "reason": "...", "reset_to": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |
| `reason` | string | no | Why it needs to reset |
| `reset_to` | string | no | Target state to reset to (e.g. "draft", "implement"). Omit to go back one step. |

### cancel

Cancel a feature

```json
{"entity": "feature", "action": "cancel", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |

### tick

Advance feature one step in the pipeline (used by loop)

```json
{"entity": "feature", "action": "tick", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |

### poke

Run state-specific checks on a feature (e.g. PR merged detection)

```json
{"entity": "feature", "action": "poke", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity |

### prompt

Build the agent prompt for a feature

```json
{"entity": "feature", "action": "prompt", "data": {"branch": "...", "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `branch` | string | no | Branch name (included in task prompts for context) |
| `id` | integer | yes | ID of the entity |

### add_task

Assign a task to this feature

```json
{"entity": "feature", "action": "add_task", "data": {"id": 1, "task_id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the parent entity (feature or component) |
| `task_id` | integer | yes | ID of the task to assign |

### add_document

Link a document to this feature

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

List documents linked to this feature

```json
{"entity": "feature", "action": "list_documents", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

