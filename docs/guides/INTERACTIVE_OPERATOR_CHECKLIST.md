# Interactive Operator Checklist

## Before launch

- open a real SSH terminal
- export `DEEPSEEK_API_KEY`
- confirm the interactive binary exists

Example:

```bash
export DEEPSEEK_API_KEY="your-key"
cd /home/pi/crush-riscv64/forks/crush
ls -l ./crush-interactive-riscv64
```

## Start the interactive TUI

```bash
/home/pi/crush-riscv64/run-interactive-riscv64.sh ./crush-interactive-riscv64
```

## First useful checks

After the UI opens:

1. Type a short prompt.
2. Press `Enter`.
3. Wait for the first assistant response.
4. Press `Ctrl+S` and confirm a session list can open.
5. Press `Ctrl+L` and confirm model selection can open.
6. Press `Ctrl+C` to leave the TUI cleanly.

## Editor and chat basics

- `Enter` : send message
- `Ctrl+J` : newline
- `Tab` : switch focus
- `Ctrl+N` : new session
- `Ctrl+S` : sessions
- `Ctrl+L` : models
- `Ctrl+C` : quit

## If it does not work

- if you launched it from redirected stdin, restart from a normal SSH terminal
- if you see auth failures, re-export `DEEPSEEK_API_KEY`
- if the binary is missing, rebuild it with `build-interactive-riscv64.sh`
- if you need a scripted proof, use `test-interactive-riscv64.py`
