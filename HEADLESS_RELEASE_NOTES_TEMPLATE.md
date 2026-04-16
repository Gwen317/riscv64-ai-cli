# Headless Release Notes Template

## Summary

Release artifact:

- `crush-headless-riscv64`

Bundle:

- `crush-headless-riscv64-bundle.tar.gz`

Validated target:

- `linux/riscv64`

## What this release is for

This artifact is the smallest validated headless `Crush` slice for remote-model
AI coding workflows on `riscv64 Linux`.

## Included command surface

- `dirs`
- `models`
- `run`

## Included bundle files

- binary
- checksum
- deployment guide
- release guide
- DeepSeek-compatible config template
- upstream commit marker
- manifest

## Validation performed

- build on native `riscv64`
- bundle generation
- provider-backed smoke run

## Known limits

- no interactive TUI
- no login flow
- no client/server mode in headless builds
- no MCP-enabled headless runs
- no LSP-default-enriched headless behavior

## Upstream commit

- `<fill commit here>`

## Smoke proof

- expected token: `<fill smoke token here>`

## Notes

- Mention any board-image-specific behavior here.
- Mention whether the binary is static or interpreter-bound here.
