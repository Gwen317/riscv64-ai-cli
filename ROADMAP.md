# Roadmap

## Current phase

The project has reached a strong validation baseline:

- `headless` build works on native `riscv64 Linux`
- headless bundle, release, verify, and pipeline wrappers all work
- `interactive` build works on native `riscv64 Linux`
- a minimal interactive prompt/response loop has been verified through pseudo-tty automation

## Phase 1: Stabilize delivery

Goal:

- keep the current `headless` release flow stable and easy to reproduce

Tasks:

- keep bundle and pipeline scripts working on the board
- reduce manual steps in deployment and verification
- improve release note generation and bundle metadata

## Phase 2: Improve interactive usability

Goal:

- make the interactive TUI easier to launch and use manually on the target

Tasks:

- document the practical SSH-based workflow
- validate session continuation and longer chat loops
- identify and fix the first real TUI usability regressions on `riscv64`

## Phase 3: Refine source boundaries

Goal:

- make the `headless` and `interactive` lanes cleaner to maintain

Tasks:

- continue trimming non-essential dependencies from `headless`
- keep shared code paths intentional and well documented
- reduce accidental coupling between delivery lanes

## Phase 4: Upstream and maintenance strategy

Goal:

- decide how this work should live long-term

Options:

- maintain this repo as a practical downstream adaptation workspace
- keep a long-lived `forks/crush` branch strategy
- split stable patches into a cleaner upstream-facing patch set later

## Non-goals for now

- local model inference
- desktop GUI or browser-first frontend
- full parity with every upstream feature before `riscv64` basics are stable
