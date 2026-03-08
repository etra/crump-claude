#!/usr/bin/env bash
set -euo pipefail

# PreToolUse hook — only check Bash calls that invoke crump
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Skip if this Bash call isn't a crump command
case "$COMMAND" in
  crump\ *|crump) ;;
  *) exit 0 ;;
esac

# Check if crump is installed
if ! command -v crump &>/dev/null; then
  cat >&2 <<'EOF'
crump is not installed or not in PATH.

Install with:
  cargo install --path crates/crump

Or build and add to PATH:
  cd crump && cargo build --release
  export PATH="$PWD/target/release:$PATH"
EOF
  exit 2
fi

exit 0
