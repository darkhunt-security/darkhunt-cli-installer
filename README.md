# darkhunt-cli

Run adversarial attack assessments against AI applications — from your
laptop, your CI pipeline, or anywhere in between.

`darkhunt-cli` orchestrates red-team campaigns against AI systems you own:
chatbots, agents, RAG apps, anything you can `POST` a prompt to. The
[Darkhunt](https://darkhunt.ai) backend generates the attack prompts and
judges the replies; the CLI is the thin orchestrator that holds the local
connection to your target and shuttles replies back. Model credentials,
judge prompts, and search algorithms stay on the server — the CLI just
speaks HTTPS.

## What you can do with it

- **Block bad releases in CI.** `darkhunt-cli scan --target my-chatbot
  --fail-on-attack` fails the build the moment the model leaks a secret,
  breaks a policy rule, or otherwise misbehaves. JUnit XML output drops
  straight into your existing test-report pipeline.
- **Attack live, interactively.** `darkhunt-cli playground start --target
  my-chatbot --goal "extract the system prompt" --agents 5` spins up
  parallel attack agents and streams their progress to your terminal +
  the dashboard. Cancel mid-run with Ctrl-C.
- **Wire any HTTP-shaped AI app without writing code.** JSON POST,
  form-data, OpenAI-compat, custom auth schemes — all configurable via
  YAML. See [`examples/targets.yaml`](./examples/targets.yaml).
- **Author custom target plugins in TypeScript** when the wire format
  needs more than templating (cookies, websockets, multi-step auth).
- **Build reference corpora** from real documents (board reports,
  contracts, etc.) so generated attacks mimic content shapes your app
  actually handles.
- **Generate attack datasets** — PDFs, HTML, and text files with embedded
  prompt injections, shaped by a corpus or an attack library.
- **Discover novel attack prompts** with the server-side search and
  accumulate them into reusable attack libraries.


Every campaign, run, turn, and judge verdict is recorded in your Darkhunt
workspace, so findings show up in the dashboard with full traceability —
local results aren't a black box.

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

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/darkhunt-security/darkhunt-cli-installer/main/uninstall.sh | bash
```

By default this removes the binary but **preserves** your config and logs at `~/.darkhunt/`. To also wipe config + logs:

```bash
curl -fsSL https://raw.githubusercontent.com/darkhunt-security/darkhunt-cli-installer/main/uninstall.sh | PURGE=1 bash
```

`INSTALL_DIR` is honored just like in `install.sh`.

## Releases

Binaries and checksums are published on the [Releases](https://github.com/darkhunt-security/darkhunt-cli-installer/releases) page.

## Usage

```bash
darkhunt-cli --help
```

See the [Darkhunt docs](https://darkhunt.ai/docs) for full usage.

## Examples & docs

- [`examples/targets.yaml`](./examples/targets.yaml) — commented
  configuration template for a single target, JSON-POST shape with bearer
  auth and inline notes for OpenAI-compat / form-data / custom auth
  variants. Copy it to `.darkhunt/targets.yaml` in your project and edit
  the UUIDs + connection details, or run `darkhunt-cli target init
  --application <uuid>` to have the CLI scaffold the entry for you.
- [CLI recipes on docs.darkhunt.ai](https://docs.darkhunt.ai/darkhunt-ai-security/cli/recipes)
  — end-to-end walkthroughs for custom targets, attack libraries, dataset
  generation, attack discovery, and CI/CD integration.
