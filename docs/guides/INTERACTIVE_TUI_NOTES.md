# Interactive TUI Notes

## Current status

- The interactive `Crush` binary builds on the `riscv64` target.
- Under a pseudo-tty, the UI reaches terminal setup and enters the alternate
  screen instead of failing immediately.
- A minimal real chat loop has been validated by launching the TUI under a
  pseudo-tty, sending a prompt, and confirming both user and assistant messages
  were persisted to the session database.
- Non-tty startup still fails, which is expected for the interactive build.

## Practical launch

On the target board:

```bash
cd /home/pi/crush-riscv64/forks/crush
export DEEPSEEK_API_KEY="your-key"
/home/pi/crush-riscv64/build-interactive-riscv64.sh /home/pi/crush-riscv64/forks/crush crush-interactive-riscv64
/home/pi/crush-riscv64/run-interactive-riscv64.sh /home/pi/crush-riscv64/forks/crush/crush-interactive-riscv64
```

## Practical usage

Once the TUI is open:

- type directly in the editor area
- press `Enter` to send the current message
- press `Ctrl+J` to insert a newline
- press `Tab` to change focus
- press `Ctrl+N` to start a new session
- press `Ctrl+S` to open sessions
- press `Ctrl+L` to open model selection
- press `Ctrl+C` to quit

## Session continuation

Interactive root supports:

- `--continue` to reopen the most recent session
- `--session <id>` to reopen a specific session

Examples:

```bash
/home/pi/crush-riscv64/run-interactive-riscv64.sh /home/pi/crush-riscv64/forks/crush/crush-interactive-riscv64 --continue
```

```bash
/home/pi/crush-riscv64/run-interactive-riscv64.sh /home/pi/crush-riscv64/forks/crush/crush-interactive-riscv64 --session <id>
```

Validated continuation proof:

- first prompt and second prompt can be sent in separate launches
- `--continue` reuses the same session id
- both assistant replies were confirmed in the session database

## Recommended SSH workflow

On the board:

```bash
export DEEPSEEK_API_KEY="your-key"
cd /home/pi/crush-riscv64/forks/crush
/home/pi/crush-riscv64/run-interactive-riscv64.sh ./crush-interactive-riscv64
```

If you rebuild often:

```bash
export DEEPSEEK_API_KEY="your-key"
cd /home/pi/crush-riscv64/forks/crush
/home/pi/crush-riscv64/build-interactive-riscv64.sh /home/pi/crush-riscv64/forks/crush crush-interactive-riscv64
/home/pi/crush-riscv64/run-interactive-riscv64.sh ./crush-interactive-riscv64
```

For an automated smoke check on the target:

```bash
export DEEPSEEK_API_KEY="your-key"
/home/pi/crush-riscv64/test-interactive-riscv64.py /home/pi/crush-riscv64/forks/crush/crush-interactive-riscv64 INTERACTIVE_SMOKE_OK
```

For a build + smoke verification wrapper:

```bash
export DEEPSEEK_API_KEY="your-key"
/home/pi/crush-riscv64/verify-interactive-riscv64.sh /home/pi/crush-riscv64/forks/crush crush-interactive-verify INTERACTIVE_VERIFY_OK
```

For shell helper functions on the target:

```bash
source /home/pi/crush-riscv64/interactive-shell-functions.sh
crushi-build
crushi-run
crushi-continue
```

For starting the TUI against your current directory:

```bash
cd /path/to/project
source /home/pi/crush-riscv64/interactive-shell-functions.sh
crushi-here
```

## Notes

- Launch this from a real SSH terminal or local tty, not from redirected stdin.
- The wrapper uses `/lib/ld-linux-riscv64-lp64d.so.1` explicitly because that
  is more reliable on the current board image than direct execution.
- This path is still experimental compared with the validated headless build.
- The current validated claim is not “every TUI feature is perfect”, but “a real prompt/response chat loop works on the target”.
