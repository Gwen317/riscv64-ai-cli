# Headless Cleanup Plan

## Goal

Produce a smallest-runnable `Crush` headless build path that keeps:

- `run`
- provider/model configuration
- session persistence
- file read/write
- search
- diff/patch
- shell

and reduces or removes first-pass dependence on:

- interactive TUI startup
- desktop clipboard/notification behavior
- eager LSP startup
- eager MCP startup
- update-check side effects

## Constraints

- Preserve the currently verified non-interactive behavior.
- Prefer isolating subsystems over broad rewrites.
- Keep the diff reversible.
- Add tests before refactor where current behavior is not already protected.

## Planned steps

1. Lock current headless-critical behavior with tests.
   - `MaybePrependStdin`
   - non-interactive command registration / headless root surface
   - any new headless option defaults that gate startup side effects

2. Split root command surfaces.
   - `!headless`: existing interactive root behavior
   - `headless`: non-interactive root behavior without TUI entry

3. Split shared setup code from interactive root code.
   - keep workspace/config/db helpers in shared files
   - keep TUI-specific imports and `RunE` in non-headless files only

4. Add app construction options.
   - default app path keeps existing behavior
   - headless app path skips update checks and eager MCP/LSP startup

5. Route local `run` through headless app initialization.
   - keep provider/session/tool behavior
   - avoid unnecessary interactive/UI startup cost

6. Verify:
   - targeted tests
   - `go build` default
   - `go build -tags headless`
   - remote smoke checks for `run`

## Expected first-pass output

- A `headless` build tag that compiles a minimal CLI surface
- A local non-interactive path that uses headless app initialization
- Notes and scripts updated to reflect the new build entry
