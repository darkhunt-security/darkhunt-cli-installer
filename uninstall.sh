#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
BIN="${INSTALL_DIR}/darkhunt-cli"
DATA_DIR="$HOME/.darkhunt"
PURGE="${PURGE:-0}"

echo "Uninstalling darkhunt-cli..."

if [ -f "$BIN" ] || [ -L "$BIN" ]; then
  rm -f "$BIN"
  echo "  Removed binary: $BIN"
else
  echo "  Binary not found at $BIN (already uninstalled?)"
fi

if [ -d "$DATA_DIR" ]; then
  if [ "$PURGE" = "1" ]; then
    rm -rf "$DATA_DIR"
    echo "  Removed config and logs: $DATA_DIR"
  else
    echo ""
    echo "  Config and logs preserved at: $DATA_DIR"
    echo "    - credentials.json"
    echo "    - connectors.yaml"
    echo "    - logs/"
    echo "  To remove them as well, re-run with PURGE=1:"
    echo "    PURGE=1 bash uninstall.sh"
  fi
fi

echo ""
echo "Done."
