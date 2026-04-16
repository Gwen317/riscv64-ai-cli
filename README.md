# riscv64-ai-cli

Workspace for validating and packaging a `riscv64 Linux` AI coding CLI based on
`Crush`, with two parallel delivery lanes:

- a minimal `headless` runtime for stable automation and release packaging
- a recovering `interactive` TUI line for real terminal chat development

## Project Focus

This repository tracks the adaptation work rather than vendoring the upstream
codebase directly. The nested upstream clone remains under `forks/crush/` and is
kept outside the top-level repository history on purpose.

Current MVP priorities:

- remote provider access
- session persistence
- file read/write
- search
- diff/patch
- controlled shell execution

## Current Status

- Native `riscv64 Linux` builds are validated on the K1 MUSE Pi Pro target
- `headless` is now the primary delivery lane:
  - builds on the target
  - packages into a reusable bundle
  - emits checksums and `manifest.json`
  - supports one-command verify and pipeline wrappers
- `interactive` is now a viable secondary lane:
  - builds on the target
  - enters a real TTY session
  - has a validated minimal prompt/response loop

## Repository Structure

- [`forks/`](./forks) : upstream source clones kept outside the top-level repo history
- [`scripts/`](./scripts) : build, package, verify, and pipeline wrappers
- [`docs/plans/`](./docs/plans) : project plans and scope documents
- [`docs/guides/`](./docs/guides) : deployment, release, and interaction guides
- [`docs/notes/`](./docs/notes) : evidence, decisions, and validation notes

## Key Entrypoints

- Headless build:
  [`build-headless-riscv64.sh`](./scripts/build-headless-riscv64.sh)
- Headless package:
  [`package-headless-riscv64.sh`](./scripts/package-headless-riscv64.sh)
- Headless verify:
  [`verify-headless-riscv64.sh`](./scripts/verify-headless-riscv64.sh)
- Headless pipeline:
  [`run-headless-pipeline.sh`](./scripts/run-headless-pipeline.sh)
- Interactive build:
  [`build-interactive-riscv64.sh`](./scripts/build-interactive-riscv64.sh)
- Interactive run:
  [`run-interactive-riscv64.sh`](./scripts/run-interactive-riscv64.sh)
- Interactive verify:
  [`verify-interactive-riscv64.sh`](./scripts/verify-interactive-riscv64.sh)
- Full dual-lane pipeline:
  [`run-full-riscv64-pipeline.sh`](./scripts/run-full-riscv64-pipeline.sh)

## Documentation

- Primary plan: [CRUSH_RISCV64_PLAN.md](/d:/Users/Gwen317/Desktop/Program/riscv64/docs/plans/CRUSH_RISCV64_PLAN.md)
- Dependency audit: [dependency-audit.md](/d:/Users/Gwen317/Desktop/Program/riscv64/docs/notes/dependency-audit.md)
- Build log: [build-log.md](/d:/Users/Gwen317/Desktop/Program/riscv64/docs/notes/build-log.md)
- Runtime test: [runtime-test.md](/d:/Users/Gwen317/Desktop/Program/riscv64/docs/notes/runtime-test.md)
- Decisions: [decisions.md](/d:/Users/Gwen317/Desktop/Program/riscv64/docs/notes/decisions.md)
- Headless cleanup plan: [headless-cleanup-plan.md](/d:/Users/Gwen317/Desktop/Program/riscv64/docs/notes/headless-cleanup-plan.md)
- Headless deploy guide: [HEADLESS_DEPLOY.md](/d:/Users/Gwen317/Desktop/Program/riscv64/docs/guides/HEADLESS_DEPLOY.md)
- Headless release guide: [HEADLESS_RELEASE.md](/d:/Users/Gwen317/Desktop/Program/riscv64/docs/guides/HEADLESS_RELEASE.md)
- Release notes template: [HEADLESS_RELEASE_NOTES_TEMPLATE.md](/d:/Users/Gwen317/Desktop/Program/riscv64/docs/guides/HEADLESS_RELEASE_NOTES_TEMPLATE.md)
- Interactive notes: [INTERACTIVE_TUI_NOTES.md](/d:/Users/Gwen317/Desktop/Program/riscv64/docs/guides/INTERACTIVE_TUI_NOTES.md)
