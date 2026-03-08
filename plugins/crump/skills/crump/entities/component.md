# component

Modules or subsystems of the project — used to categorize tasks by area (e.g. backend, auth, UI)

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `body` | string? |  |
| `id` | integer |  |
| `parent_id` | integer? |  |
| `prefix` | string |  |
| `title` | string |  |

## Relations

- has many `task`
- has many `document`

## Actions

### create

Create a new component to represent a module or subsystem

```json
{"entity": "component", "action": "create", "data": {"body": "...", "parent_id": 1, "prefix": "...", "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | Description of what this component covers |
| `parent_id` | integer | no | Parent component ID for nested hierarchies |
| `prefix` | string | yes | Short prefix for task labeling (e.g. BE, FE, AUTH) |
| `title` | string | yes | Name of the module or subsystem (e.g. Authentication, API Gateway) |

### get

Retrieve a component and its details by ID

```json
{"entity": "component", "action": "get", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

### list

List all components — use to see the system architecture breakdown

```json
{"entity": "component", "action": "list"}
```

### update

Update component fields — name or description

```json
{"entity": "component", "action": "update", "data": {"body": "...", "id": 1, "parent_id": 1, "prefix": "...", "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | New description |
| `id` | integer | yes | ID of the component to update |
| `parent_id` | integer | no | New parent component ID |
| `prefix` | string | no | New prefix |
| `title` | string | no | New name |

### delete

Permanently remove a component (does not delete its tasks)

```json
{"entity": "component", "action": "delete", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

### add_task

Assign an existing task to this component

```json
{"entity": "component", "action": "add_task", "data": {"id": 1, "task_id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the parent entity (feature or component) |
| `task_id` | integer | yes | ID of the task to assign |

### add_document

Link a document to this component as reference material

```json
{"entity": "component", "action": "add_document", "data": {"document_id": 1, "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `document_id` | integer | yes | ID of the document to link or unlink |
| `id` | integer | yes | ID of the parent entity (task, feature, or component) |

### remove_document

Remove a document link from this component

```json
{"entity": "component", "action": "remove_document", "data": {"document_id": 1, "id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `document_id` | integer | yes | ID of the document to link or unlink |
| `id` | integer | yes | ID of the parent entity (task, feature, or component) |

### list_documents

List all documents linked to this component

```json
{"entity": "component", "action": "list_documents", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

