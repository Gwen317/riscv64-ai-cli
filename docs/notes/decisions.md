# Decisions

## 2026-04-15

### Use the K1 MUSE Pi Pro as the primary validation lane

Reason:

- Native `riscv64` execution is available now through SSH
- Local Windows environment lacks `go`
- Docker is present locally but not currently usable because the Linux engine is down

### Treat `GOEXPERIMENT=greenteagc` as non-blocking and currently stale

Reason:

- It caused an immediate build failure on the effective `go1.26.2` toolchain
- Removing it allowed full `go build ./...` success on the board

### Carry a board-specific ELF interpreter override for runnable binaries

Chosen flag:

- `-ldflags='-I /lib/ld-linux-riscv64-lp64d.so.1'`

Reason:

- Default output targeted `/lib/ld.so.1`
- That path is absent on the board image
- The explicit interpreter produced a working startup path

### Degrade native clipboard on `linux/riscv64`

Reason:

- Clipboard is not required for the MVP
- The native clipboard path was a clear UI-edge risk on this headless board
- Build tags are a narrow, reversible way to keep the runtime path simpler

### Prefer a headless MVP over full feature parity

Reason:

- Provider, session, file tools, diff/patch, search, and shell are the core value
- TUI, notifications, clipboard, LSP, MCP, and server/client layers expand risk surface without being necessary for first validation

### Use DeepSeek as the first live provider validation lane

Reason:

- `Crush` supports DeepSeek through `openai-compat`
- It gives a fast way to validate the remote-model half of the MVP on `riscv64`
- The first live request and a repo file-read prompt both succeeded on the board

### Use config-level `allowed_tools` for headless validation

Reason:

- It keeps the non-interactive validation lane simple
- It avoids depending on `yolo` behavior during CLI invocation
- It lets us validate search, shell, edit, and write in a reproducible way on the board

### Introduce a first-pass `headless` build tag

Reason:

- It gives us a concrete minimal target surface instead of only a runtime convention
- It lets the default binary keep interactive behavior while the headless lane evolves independently
- The first pass already compiles and runs provider-backed non-interactive requests on the board

### Prefer explicit fail-fast contracts over partial headless support

Reason:

- Headless mode currently skips eager MCP and server startup paths
- Explicit rejection for unsupported MCP and client/server combinations is safer than allowing ambiguous half-working behavior
- This keeps the current headless slice self-consistent while deeper dependency pruning remains future work

### Use build-tag helpers to keep spinner behavior out of the headless compile path

Reason:

- `run` and non-interactive app execution still need reasonable UX in normal builds
- Headless builds do not need lipgloss/style/animation-backed spinners
- Build-tag split helpers let the default binary keep polish while headless compiles against a lighter path

### Keep trimming the headless compile surface, not just the help output

Reason:

- A smaller `go list -tags headless` file set is a better signal than only hiding commands from `--help`
- `projects`, `stats`, `session`, and server-only platform helpers were all removable from the headless build without breaking the validated runtime path
- This keeps the MVP closer to a real dedicated product slice instead of a UI-shaped binary with hidden features

### Remove `logs` and `update-providers` from the first-pass headless MVP

Reason:

- They are operational conveniences, not core runtime requirements for provider-backed coding loops
- Removing them further reduced the headless `internal/cmd` compile set
- The validated `run/models/dirs` workflow remained intact after the cut

### Add a dedicated headless build wrapper

Reason:

- It gives the project a repeatable build entry instead of relying on remembered tag/env combinations
- The wrapper now successfully produces a static `riscv64` headless binary
- A dedicated entry is a better base for future release packaging and deployment scripts

### Add a release bundle wrapper for the current headless artifact

Reason:

- A single binary is useful for local testing, but a bundle is better for handoff and reuse
- The bundle now includes the binary, checksum, deployment docs, config template, and upstream commit marker
- The bundled binary has been smoke-tested successfully on the target

### Emit a machine-readable release manifest

Reason:

- Human-readable docs are useful, but handoff automation benefits from a structured file
- The release bundle now records artifact name, platform, validated commands, non-goals, and upstream commit in `manifest.json`
- This makes later packaging or CI integration easier

### Add a one-command verification wrapper

Reason:

- A release flow is more trustworthy when build, package, and smoke are exercised together
- The verification wrapper now reproduces the validated headless path on the target in one command
- This is the closest current equivalent to a lightweight CI lane for the board

### Add a board-side pipeline wrapper with logs and generated release notes

Reason:

- Repeated manual release commands are error-prone on the target board
- A single pipeline wrapper now leaves behind a timestamped log plus generated release notes inside the bundle
- This creates a practical, low-overhead substitute for formal CI on the current hardware

### Treat the interactive TUI line as viable, but still secondary to headless

Reason:

- The interactive binary now builds and can enter a real terminal UI session on the target
- A minimal prompt/response loop has been validated through pseudo-tty automation and database inspection
- The headless line remains the primary delivery track because it is already packaged and release-oriented

### Add interactive and full-pipeline verification wrappers

Reason:

- The project now has two meaningful delivery lanes, so validation should cover both
- The interactive wrapper turns a raw pseudo-tty experiment into a reusable proof step
- The full pipeline wrapper gives the board a single command that exercises headless release flow plus interactive chat viability

### Add shell helpers for manual interactive use on the target

Reason:

- A validated interactive path still feels awkward if every launch requires long manual commands
- Lightweight shell functions are a low-risk way to improve operator ergonomics without changing core runtime behavior
- This helps bridge the gap between “technically works” and “comfortable to use over SSH”

### Treat interactive session continuation as a validated capability

Reason:

- Manual development is much less useful if every restart loses the active thread
- The interactive line now has evidence that `--continue` reuses the same session and preserves chat history
- This raises the interactive path from simple viability to a more practical developer workflow
