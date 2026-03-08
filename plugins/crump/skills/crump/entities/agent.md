# agent

AI coding agents that can be assigned to tasks — the workers that execute work items

## Fields

| Field | Type | Description |
|-------|------|-------------|
| `agent_type` | `worker`, `lead` | Agent type: worker or lead |
| `config` | any | Agent configuration — provider, model, system prompt, etc. |
| `id` | integer |  |
| `name` | string |  |

## Relations

- has many `task`

## Actions

### create

Register a new AI agent that can be assigned to tasks

```json
{"entity": "agent", "action": "create", "data": {"agent_type": "...", "config": "...", "name": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `agent_type` | string | no | Agent type: worker or lead |
| `config` | string | no | Agent configuration — provider, model, system prompt, etc. |
| `name` | string | yes | Unique name to identify this agent |

### get

Retrieve an agent's details by ID

```json
{"entity": "agent", "action": "get", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

### list

List all registered agents

```json
{"entity": "agent", "action": "list"}
```

### update

Update agent fields — name or description

```json
{"entity": "agent", "action": "update", "data": {"agent_type": "...", "config": "...", "id": 1, "name": "..."}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `agent_type` | string | no | Agent type: worker or lead |
| `config` | string | no | Updated configuration |
| `id` | integer | yes | ID of the agent to update |
| `name` | string | no | New agent name |

### delete

Remove an agent registration

```json
{"entity": "agent", "action": "delete", "data": {"id": 1}}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | integer | yes | ID of the entity to retrieve or delete |

