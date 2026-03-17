#!/usr/bin/env bash
set -euo pipefail

REPO="etra/crump-claude"

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

  LATEST=$(echo "$VERSIONS" | head -1)
  read -rp "Pick a version number [1 for $LATEST]: " PICK
  PICK=${PICK:-1}

  VERSION=$(echo "$VERSIONS" | sed -n "${PICK}p")
  if [ -z "$VERSION" ]; then
    echo "Invalid selection."
    exit 1
  fi
fi

echo "Selected version: $VERSION"
echo ""

# --- Pick install directory ---
read -rp "Install directory [$DEFAULT_DIR]: " INSTALL_DIR
INSTALL_DIR=${INSTALL_DIR:-$DEFAULT_DIR}

echo ""
echo "Downloading crump $VERSION..."

DOWNLOAD_URL="https://raw.githubusercontent.com/${REPO}/${VERSION}/${BINARY_PATH}"
TMP_FILE="/tmp/crump"

curl -fsSL "$DOWNLOAD_URL" -o "$TMP_FILE"
chmod +x "$TMP_FILE"
mkdir -p "$INSTALL_DIR"
mv "$TMP_FILE" "$INSTALL_DIR/$(basename "$BINARY_PATH")"

INSTALLED="$INSTALL_DIR/$(basename "$BINARY_PATH")"
echo "Installed crump to $INSTALLED"
echo "Version: $("$INSTALLED" --version 2>/dev/null || echo 'unknown')"

# --- PATH warning ---
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
  echo ""
  echo "Warning: $INSTALL_DIR is not in your PATH."
  echo "Add it:  export PATH=\"$INSTALL_DIR:\$PATH\""
fi

echo ""

# --- Plugin install ---
read -rp "Install Claude Code plugin now? [Y/n]: " INSTALL_PLUGIN
INSTALL_PLUGIN=${INSTALL_PLUGIN:-Y}

if [[ "$INSTALL_PLUGIN" =~ ^[Yy]$ ]]; then
  echo ""
  echo "Adding marketplace..."
  claude plugin marketplace add https://github.com/etra/crump-claude
  echo "Installing plugin..."
  claude plugin install crump@crump-plugins
  echo ""
  echo "Done! Plugin installed. Run 'crump init' in your project to get started."
else
  echo ""
  echo "To install the plugin manually, run:"
  echo ""
  echo "  claude plugin marketplace add https://github.com/etra/crump-claude"
  echo "  claude plugin install crump@crump-plugins"
  echo ""
  echo "Then run 'crump init' in your project to get started."
fi
