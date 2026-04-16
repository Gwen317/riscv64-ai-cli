# Runtime Test

## Environment

- Host: `pi-board`
- User: `pi`
- Path: `/home/pi/crush-riscv64/forks/crush`
- Binary under test: `crush-riscv64-run`

## Results

### Startup

- `./crush-riscv64-run --version`
  - Passed
- `./crush-riscv64-run dirs`
  - Passed

### Provider-backed request

- Provider configured: DeepSeek via `openai-compat`
- `./crush-riscv64-run models`
  - Passed
  - Reported model: `deepseek/deepseek-chat`
- `./crush-riscv64-run run 'Reply with exactly: OK' </dev/null`
  - Passed
  - Returned: `OK`

### Non-interactive run path

- `./crush-riscv64-run run hello`
  - Initial result: appeared to hang when invoked over SSH
  - Root cause: the command was waiting on stdin, because SSH left stdin open and `run` supports stdin-prepended input
  - Retest with stdin closed: `./crush-riscv64-run run hello </dev/null`
  - Result: clean failure with `No providers configured - please run 'crush' to set up a provider interactively.`

### File-read tool path

- `./crush-riscv64-run run 'Using local tools if needed, answer with only the module path from go.mod.' </dev/null`
  - Passed
  - Output included the correct module path: `github.com/charmbracelet/crush`
  - The response also included extra natural-language preface, so strict output-shape adherence is model-dependent, but the local file-read chain worked

### Search, shell, diff, and write loop

- Smoke workspace: `/home/pi/crush-riscv64/smoke`
- Search-style prompt:
  - Prompt asked for the exact line containing `hello riscv64` from `main.go`
  - Passed
  - The response included extra prose, but it correctly identified the target line in the local file
- Shell-style prompt:
  - Prompt asked the agent to run a shell command and return only the current working directory
  - Passed
  - Returned: `/home/pi/crush-riscv64/smoke`
- Write/edit prompt:
  - Prompt changed `hello riscv64` to `hello patched riscv64`
  - Passed
  - Verified on disk: `main.go` was updated
- Diff-display prompt:
  - Prompt changed `hello patched riscv64` to `hello diffed riscv64` and asked for unified diff only
  - Passed with caveat
  - The response included brief prose before the diff, but also included the expected unified diff hunk
  - Verified on disk: `main.go` ended with `message := "hello diffed riscv64"`

### Clipboard-related adjustment

- Native clipboard support for `linux/riscv64` was disabled in the local fork by build tags
- Purpose: avoid pulling desktop/X11 clipboard behavior into the `riscv64` headless validation lane

## Not yet verified

- Persistence behavior across sessions on the board

## Current conclusion

- The binary can be built and started on the target board.
- The headless `run` path is reachable and behaves predictably once stdin is handled correctly.
- DeepSeek works as a real remote provider on the board.
- Local file reading through the provider-backed agent path is working.
- Search, shell, file editing, and diff-style output are all working in a live provider-backed loop on `riscv64`.

## Interactive line

- `crush-interactive-riscv64` builds on the target.
- Under a pseudo-tty, the interactive UI enters terminal initialization rather than failing immediately.
- A minimal real chat loop has been validated by sending a prompt through a pseudo-tty and inspecting the session database.
- Interactive smoke result:
  - user message persisted: `Reply with exactly: INTERACTIVE_TUI_OK`
  - assistant message persisted: `INTERACTIVE_TUI_OK`
- Interactive verify wrapper:
  - `verify-interactive-riscv64.sh /home/pi/crush-riscv64/forks/crush crush-interactive-verify INTERACTIVE_VERIFY_OK /tmp/interactive-verify-run`
  - Passed
  - Returned: `INTERACTIVE_VERIFY_OK`
- Full pipeline:
  - `run-full-riscv64-pipeline.sh ... HEADLESS_FULL_PIPELINE_OK INTERACTIVE_FULL_PIPELINE_OK`
  - Passed
  - Returned:
    - `HEADLESS_FULL_PIPELINE_OK`
    - `INTERACTIVE_FULL_PIPELINE_OK`

### Headless build

- `go build -tags headless -ldflags='-I /lib/ld-linux-riscv64-lp64d.so.1' -o crush-headless-riscv64 .`
  - Passed
- `crush-headless-riscv64 --help`
  - Passed
- `crush-headless-riscv64 run 'Reply with exactly: HEADLESS_OK' </dev/null`
  - Passed
  - Returned: `HEADLESS_OK`
- Headless contract guards:
  - headless non-interactive runs now reject MCP-configured setups with a clear error
  - headless builds now reject client/server mode with a clear error instead of attempting a broken mixed path
- Later headless smoke:
  - `crush-headless-v3 run "Reply with exactly: HEADLESS_V3_OK" </dev/null`
  - Passed
  - Returned: `HEADLESS_V3_OK`
- Latest headless smoke:
  - `crush-headless-v4 run "Reply with exactly: HEADLESS_V4_OK" </dev/null`
  - Passed
  - Returned: `HEADLESS_V4_OK`
- Headless surface V5:
  - `go list -tags headless -f "{{.GoFiles}}" ./internal/cmd`
  - Result:
    - `dirs.go`
    - `headless_build.go`
    - `models.go`
    - `root_clientserver_headless.go`
    - `root_headless.go`
    - `root_shared.go`
    - `run.go`
    - `run_spinner_headless.go`
    - `schema.go`
- Latest headless smoke:
  - `crush-headless-v5 run "Reply with exactly: HEADLESS_V5_OK" </dev/null`
  - Passed
  - Returned: `HEADLESS_V5_OK`
- Wrapper-built headless smoke:
  - `crush-headless-v6 run "Reply with exactly: HEADLESS_V6_OK" </dev/null`
  - Passed
  - Returned: `HEADLESS_V6_OK`
- Release-bundle smoke:
  - `test-headless-riscv64.sh /home/pi/crush-riscv64/dist/crush-headless-release-bundle/crush-headless-release HEADLESS_RELEASE_OK`
  - Passed
  - Returned: `HEADLESS_RELEASE_OK`
- Release-bundle smoke v2:
  - `test-headless-riscv64.sh /home/pi/crush-riscv64/dist/crush-headless-release-bundle/crush-headless-release HEADLESS_RELEASE_V2_OK`
  - Passed
  - Returned: `HEADLESS_RELEASE_V2_OK`
- Verify-wrapper smoke:
  - `verify-headless-riscv64.sh /home/pi/crush-riscv64/forks/crush crush-headless-verify /home/pi/crush-riscv64/dist HEADLESS_VERIFY_OK`
  - Passed
  - Returned: `HEADLESS_VERIFY_OK`
- Pipeline-wrapper smoke:
  - `run-headless-pipeline.sh /home/pi/crush-riscv64/forks/crush crush-headless-pipeline /home/pi/crush-riscv64/dist HEADLESS_PIPELINE_OK`
  - Passed
  - Returned: `HEADLESS_PIPELINE_OK`
  - Additional evidence:
    - `RELEASE_NOTES.md` generated in the bundle
    - pipeline log written under `dist/pipeline-runs/`
