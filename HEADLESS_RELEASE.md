# Headless Release

## Artifact name

Recommended artifact base name:

- `crush-headless-riscv64`

Recommended packaged bundle name:

- `crush-headless-riscv64-bundle`

## Bundle contents

- headless binary
- `SHA256` checksum file
- deployment guide
- release notes template
- DeepSeek-compatible config template
- build/runtime notes snapshot
- machine-readable manifest

## Minimal release checklist

1. Build the headless binary on the `riscv64` target.
2. Run the smoke wrapper against the built binary.
3. Copy the binary and companion docs into a clean `dist/` bundle directory.
4. Generate checksums.
5. Record the upstream commit used for the release.
6. Fill out release notes from the template.

## Automation helpers

- `release-headless-riscv64.sh` generates the bundle.
- `generate-headless-release-notes.sh` turns `manifest.json` into a release-notes draft.
- `run-headless-pipeline.sh` runs release + smoke + notes generation and stores a pipeline log.

## Current validated commands in headless surface

- `dirs`
- `models`
- `run`

## Current non-goals

- interactive TUI
- login flow
- client/server mode
- MCP-enabled headless runs
- LSP-default-enriched headless config behavior
