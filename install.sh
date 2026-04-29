#!/usr/bin/env bash
set -euo pipefail

REPO="darkhunt-security/darkhunt-cli-installer"
VERSION="${DARKHUNT_CLI_VERSION:-latest}"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"

case "$(uname -s)" in
  Linux*)  OS=linux ;;
  Darwin*) OS=darwin ;;
  *)
    echo "Unsupported OS: $(uname -s). Supported: Linux, Darwin." >&2
    exit 1
    ;;
esac

case "$(uname -m)" in
  x86_64|amd64)   ARCH=x64 ;;
  arm64|aarch64)  ARCH=arm64 ;;
  *)
    echo "Unsupported arch: $(uname -m). Supported: x86_64, arm64." >&2
    exit 1
    ;;
esac

if [ "$VERSION" = "latest" ]; then
  VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
    | grep -m1 '"tag_name"' \
    | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')
  if [ -z "$VERSION" ]; then
    echo "Failed to resolve latest release. Set DARKHUNT_CLI_VERSION explicitly." >&2
    exit 1
  fi
fi

ASSET="darkhunt-cli-${OS}-${ARCH}"
BASE_URL="https://github.com/${REPO}/releases/download/${VERSION}"
BIN_URL="${BASE_URL}/${ASSET}"
SUMS_URL="${BASE_URL}/SHA256SUMS"

mkdir -p "$INSTALL_DIR"

TMP_BIN=$(mktemp)
TMP_SUMS=$(mktemp)
trap 'rm -f "$TMP_BIN" "$TMP_SUMS"' EXIT

echo "Downloading ${ASSET} (${VERSION})..."
curl -fL --progress-bar -o "$TMP_BIN" "$BIN_URL"

if curl -fsSL -o "$TMP_SUMS" "$SUMS_URL" 2>/dev/null; then
  EXPECTED=$(awk -v f="$ASSET" '$2 == f {print $1}' "$TMP_SUMS")
  if [ -n "$EXPECTED" ]; then
    if command -v sha256sum >/dev/null 2>&1; then
      ACTUAL=$(sha256sum "$TMP_BIN" | awk '{print $1}')
    else
      ACTUAL=$(shasum -a 256 "$TMP_BIN" | awk '{print $1}')
    fi
    if [ "$ACTUAL" != "$EXPECTED" ]; then
      echo "Checksum mismatch for ${ASSET}." >&2
      echo "  expected: ${EXPECTED}" >&2
      echo "  actual:   ${ACTUAL}" >&2
      exit 1
    fi
    echo "Checksum verified."
  fi
fi

DEST="${INSTALL_DIR}/darkhunt-cli"
mv "$TMP_BIN" "$DEST"
chmod +x "$DEST"
trap - EXIT
rm -f "$TMP_SUMS"

echo ""
echo "Installed: ${DEST}"

case ":$PATH:" in
  *":${INSTALL_DIR}:"*) ;;
  *)
    echo ""
    echo "Note: ${INSTALL_DIR} is not on your PATH. Add this to your shell config:"
    echo "  export PATH=\"${INSTALL_DIR}:\$PATH\""
    ;;
esac

echo ""
echo "Next steps:"
echo "  darkhunt-cli enroll --api-key <key> --workspace <id>"
echo "  darkhunt-cli --help"
