# crush-riscv64

Work area for validating and adapting `Crush` toward a `linux/riscv64` MVP.

## Goal

Keep the local CLI runtime and remote model API flow, without local model
inference.

Primary MVP targets:

- provider access
- session persistence
- file read/write
- search
- diff/patch
- controlled shell execution

## Current status

- Upstream `Crush` cloned at `forks/crush/`
- Native `riscv64 Linux` build verified on the K1 MUSE Pi Pro target
- `go build ./...` passes on the target when `GOEXPERIMENT=greenteagc` is not set
- A runnable binary is produced on the target with a custom ELF interpreter path
- `run` works as a headless command path when stdin is closed, and currently fails cleanly with `No providers configured`
- A first-pass `-tags headless` build now compiles and can execute real non-interactive requests on the target
- A dedicated `build-headless-riscv64.sh` wrapper now produces a static headless binary on the target
- A release bundle wrapper now produces a reusable `dist/` package with binary, checksum, config template, and deployment docs
- The release bundle now also emits a machine-readable `manifest.json`
- A `verify-headless-riscv64.sh` wrapper now chains build, package, and provider-backed smoke verification
- A `run-headless-pipeline.sh` wrapper now chains release, notes generation, smoke verification, and pipeline logging

## Notes

- Primary plan: [CRUSH_RISCV64_PLAN.md](/d:/Users/Gwen317/Desktop/Program/riscv64/CRUSH_RISCV64_PLAN.md)
- Dependency audit: [notes/dependency-audit.md](/d:/Users/Gwen317/Desktop/Program/riscv64/notes/dependency-audit.md)
- Build log: [notes/build-log.md](/d:/Users/Gwen317/Desktop/Program/riscv64/notes/build-log.md)
- Runtime test: [notes/runtime-test.md](/d:/Users/Gwen317/Desktop/Program/riscv64/notes/runtime-test.md)
- Decisions: [notes/decisions.md](/d:/Users/Gwen317/Desktop/Program/riscv64/notes/decisions.md)
- Headless cleanup plan: [notes/headless-cleanup-plan.md](/d:/Users/Gwen317/Desktop/Program/riscv64/notes/headless-cleanup-plan.md)
- Deployment guide: [HEADLESS_DEPLOY.md](/d:/Users/Gwen317/Desktop/Program/riscv64/HEADLESS_DEPLOY.md)
- Release guide: [HEADLESS_RELEASE.md](/d:/Users/Gwen317/Desktop/Program/riscv64/HEADLESS_RELEASE.md)
- Release notes template: [HEADLESS_RELEASE_NOTES_TEMPLATE.md](/d:/Users/Gwen317/Desktop/Program/riscv64/HEADLESS_RELEASE_NOTES_TEMPLATE.md)
- Interactive notes: [INTERACTIVE_TUI_NOTES.md](/d:/Users/Gwen317/Desktop/Program/riscv64/INTERACTIVE_TUI_NOTES.md)
