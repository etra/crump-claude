# project

Git repositories within the workspace — each project maps to a directory path configured per workstation

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer |  |
| `name` | string |  |
| `origin` | string? | Origin URL (e.g. GitHub repository URL) |

## Relations

- has many `component`

## Actions

### create

Create a project

```json
{"entity": "project", "action": "create", "data": {"name": "...", "origin": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | yes | Project name (typically the git repo directory name) |
| `origin` | string | no | Origin URL (e.g. GitHub repository URL) |

### get

Get a project by ID

```json
{"entity": "project", "action": "get", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

### list

List all projects

```json
{"entity": "project", "action": "list"}
```

### update

Update project fields

```json
{"entity": "project", "action": "update", "data": {"id": 1, "name": "...", "origin": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the project to update |
| `name` | string | no | New project name |
| `origin` | string | no | Origin URL (e.g. GitHub repository URL) |

### delete

Delete a project

```json
{"entity": "project", "action": "delete", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

