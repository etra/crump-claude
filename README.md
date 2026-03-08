# crump — create, read, update, and manage projects

Claude Code plugin for crump — a project management tool built for AI coding agents.

## Prerequisites

- [Claude Code](https://claude.ai/code)
- [Git](https://git-scm.com/)

## Installation

### crump setup

Download the binary and add it to your PATH.

### Claude setup

Add the marketplace:

```bash
claude plugin marketplace add https://github.com/etra/crump-claude
```

Install the plugin:

```bash
claude plugin install crump@crump-plugins
```

## Updating

Update the marketplace:

```bash
claude plugin marketplace update crump-plugins
```

Update the plugin:

```bash
claude plugin update crump@crump-plugins
```
