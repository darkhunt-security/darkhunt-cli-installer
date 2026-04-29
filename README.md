# darkhunt-cli

Public distribution channel for the [Darkhunt](https://darkhunt.ai) command-line tool.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/darkhunt-security/darkhunt-cli-installer/main/install.sh | bash
```

The installer downloads a single self-contained binary (no Node.js or other runtime required) for your platform and installs it to `~/.local/bin/darkhunt-cli`.

Supported platforms: `linux-x64`, `linux-arm64`, `darwin-x64`, `darwin-arm64`.

### Options

- `DARKHUNT_CLI_VERSION=v0.1.0-build.42` — pin a specific release.
- `INSTALL_DIR=/usr/local/bin` — install to a different directory (must be writable; use `sudo` if needed).

### Verify

The installer downloads `SHA256SUMS` alongside the binary and verifies the checksum before installing.

## Releases

Binaries and checksums are published on the [Releases](https://github.com/darkhunt-security/darkhunt-cli-installer/releases) page.

## Usage

```bash
darkhunt-cli --help
```

See the [Darkhunt docs](https://darkhunt.ai/docs) for full usage.
