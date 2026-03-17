#!/usr/bin/env bash
set -euo pipefail

REPO="etra/crump-claude"

# Check if we can prompt the user
INTERACTIVE=false
if [ -t 0 ]; then
  INTERACTIVE=true
fi

prompt() {
  local var_name="$1" prompt_text="$2" default="$3"
  if $INTERACTIVE; then
    read -rp "$prompt_text" "$var_name"
  fi
  eval "${var_name}=\${${var_name}:-$default}"
}

# --- Detect OS and architecture ---
OS=$(uname -s)
ARCH=$(uname -m)

case "$OS" in
  Darwin)
    case "$ARCH" in
      arm64|aarch64) BINARY_PATH="crump/apple-aarch64/crump" ;;
      x86_64) BINARY_PATH="crump/apple-x86_64/crump" ;;
      *) echo "Unsupported Mac architecture: $ARCH"; exit 1 ;;
    esac
    DEFAULT_DIR="$HOME/.local/bin"
    ;;
  Linux)
    case "$ARCH" in
      x86_64) BINARY_PATH="crump/linux-x86_64/crump" ;;
      *) echo "Unsupported Linux architecture: $ARCH"; exit 1 ;;
    esac
    DEFAULT_DIR="$HOME/.local/bin"
    ;;
  *)
    echo "Unsupported OS: $OS"
    echo "Windows users: download crump.exe from https://github.com/etra/crump-claude/releases"
    exit 1
    ;;
esac

echo "Detected: $OS ($ARCH)"
echo ""

# --- Pick version ---
echo "Fetching available versions..."
VERSIONS=$(curl -fsSL "https://api.github.com/repos/${REPO}/tags" \
  | grep '"name"' | head -10 | sed 's/.*"name": "\(.*\)".*/\1/')

if [ -z "$VERSIONS" ]; then
  echo "No tagged versions found. Installing from main branch."
  VERSION="main"
else
  LATEST=$(echo "$VERSIONS" | head -1)

  if $INTERACTIVE; then
    echo "Available versions:"
    i=1
    while IFS= read -r v; do
      if [ "$i" -eq 1 ]; then
        echo "  $i) $v (latest)"
      else
        echo "  $i) $v"
      fi
      i=$((i + 1))
    done <<< "$VERSIONS"
    echo ""

    prompt PICK "Pick a version number [1 for $LATEST]: " "1"

    VERSION=$(echo "$VERSIONS" | sed -n "${PICK}p")
    if [ -z "$VERSION" ]; then
      echo "Invalid selection."
      exit 1
    fi
  else
    VERSION="$LATEST"
  fi
fi

echo "Installing crump $VERSION..."
echo ""

# --- Pick install directory ---
prompt INSTALL_DIR "Install directory [$DEFAULT_DIR]: " "$DEFAULT_DIR"

echo ""
echo "Downloading..."

TMP_FILE="/tmp/crump"

# GitHub raw endpoint doesn't serve large files; use the Git blob API instead
SHA=$(curl -fsSL "https://api.github.com/repos/${REPO}/contents/${BINARY_PATH}?ref=${VERSION}" \
  | grep '"sha"' | head -1 | sed 's/.*"sha": "\(.*\)".*/\1/')

if [ -z "$SHA" ]; then
  echo "Error: could not find binary at ${BINARY_PATH} for version ${VERSION}"
  exit 1
fi

curl -fsSL -H "Accept: application/vnd.github.raw+json" \
  "https://api.github.com/repos/${REPO}/git/blobs/${SHA}" -o "$TMP_FILE"
chmod +x "$TMP_FILE"
mkdir -p "$INSTALL_DIR"
mv "$TMP_FILE" "$INSTALL_DIR/crump"

INSTALLED="$INSTALL_DIR/crump"
echo "Installed crump to $INSTALLED"
echo "Version: $("$INSTALLED" --version 2>/dev/null || echo 'unknown')"

# --- PATH warning ---
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
  echo ""
  echo "Warning: $INSTALL_DIR is not in your PATH."
  echo "Add this to your shell profile (~/.zshrc or ~/.bashrc):"
  echo ""
  echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
  echo ""
  echo "Then restart your terminal or run: source ~/.zshrc"
fi

echo ""

# --- Plugin install ---
prompt INSTALL_PLUGIN "Install Claude Code plugin now? [Y/n]: " "Y"

if [[ "$INSTALL_PLUGIN" =~ ^[Yy]$ ]]; then
  echo ""
  echo "Adding marketplace..."
  claude plugin marketplace add https://github.com/etra/crump-claude
  echo "Installing plugin..."
  claude plugin install crump@crump-plugins
  echo ""
  echo "Done! Run 'crump workspace init' in your project to get started."
else
  echo ""
  echo "To install the plugin later:"
  echo ""
  echo "  claude plugin marketplace add https://github.com/etra/crump-claude"
  echo "  claude plugin install crump@crump-plugins"
  echo ""
  echo "Then run 'crump workspace init' in your project to get started."
fi
