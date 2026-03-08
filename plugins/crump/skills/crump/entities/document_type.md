# document_type

Classification labels for documents — e.g. 'spec', 'design', 'runbook', 'adr'

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `body` | string? |  |
| `id` | integer |  |
| `parent_id` | integer? |  |
| `title` | string |  |

## Relations

- has many `document`

## Actions

### create

Create a new document type classification (e.g. spec, design, adr)

```json
{"entity": "document_type", "action": "create", "data": {"body": "...", "parent_id": 1, "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | Description of what this document type is for |
| `parent_id` | integer | no | Parent type ID for hierarchical classification |
| `title` | string | yes | Type name (e.g. spec, design, adr, runbook) |

### get

Retrieve a document type by ID

```json
{"entity": "document_type", "action": "get", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

### list

List all available document types

```json
{"entity": "document_type", "action": "list"}
```

### update

Update document type fields — name or description

```json
{"entity": "document_type", "action": "update", "data": {"body": "...", "id": 1, "parent_id": 1, "title": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `body` | string | no | New description |
| `id` | integer | yes | ID of the document type to update |
| `parent_id` | integer | no | New parent type ID |
| `title` | string | no | New type name |

### delete

Remove a document type classification

```json
{"entity": "document_type", "action": "delete", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

