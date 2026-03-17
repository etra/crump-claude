# Updating

## Update the binary

Re-run the install script — it will let you pick a version and overwrites the existing binary:

```bash
curl -fsSL https://raw.githubusercontent.com/etra/crump-claude/main/install-crump.sh | bash
```

Or download manually from the [releases page](https://github.com/etra/crump-claude/releases).

## Update the plugin

```bash
claude plugin marketplace update crump-plugins
claude plugin update crump@crump-plugins
```

## Regenerate entity docs

If you're developing crump and changed the entity registry:

```bash
cd crump/  # the Rust workspace
cargo xtask generate-entities
```

This regenerates the skill entity docs in `crump-claude/plugins/crump/skills/crump/entities/`.
