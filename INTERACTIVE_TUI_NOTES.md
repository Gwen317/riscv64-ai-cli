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

For an automated smoke check on the target:

```bash
export DEEPSEEK_API_KEY="your-key"
/home/pi/crush-riscv64/test-interactive-riscv64.py /home/pi/crush-riscv64/forks/crush/crush-interactive-riscv64 INTERACTIVE_SMOKE_OK
```

## Notes

- Launch this from a real SSH terminal or local tty, not from redirected stdin.
- The wrapper uses `/lib/ld-linux-riscv64-lp64d.so.1` explicitly because that
  is more reliable on the current board image than direct execution.
- This path is still experimental compared with the validated headless build.
