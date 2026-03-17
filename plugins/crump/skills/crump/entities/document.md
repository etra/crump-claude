# document

Knowledge artifacts — specs, design docs, notes, or any reference material linkable to tasks, features, or components

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `body` | string? |  |
| `document_type_id` | integer? |  |
| `id` | integer |  |
| `title` | string |  |

## Relations

- has one `document_type`
- has many `task`
- has many `feature`
- has many `component`

## Actions

### create

Create a document

```json
{"entity": "document", "action": "create", "data": {"body": "...", "document_type_id": 1, "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | Full document content — markdown supported |
| `document_type_id` | integer | no | Classification type (references document_type entity) |
| `title` | string | yes | Document title (e.g. "API Specification", "Auth Design Doc") |

### get

Get a document by ID

```json
{"entity": "document", "action": "get", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

### list

List all documents

```json
{"entity": "document", "action": "list"}
```

### update

Update document fields

```json
{"entity": "document", "action": "update", "data": {"body": "...", "document_type_id": 1, "id": 1, "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | New content |
| `document_type_id` | integer | no | New classification type |
| `id` | integer | yes | ID of the document to update |
| `title` | string | no | New title |

### delete

Delete a document

```json
{"entity": "document", "action": "delete", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

