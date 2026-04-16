# Headless Deploy

## Goal

Build and verify the smallest validated `riscv64 Linux` headless binary from
the current workspace.

## Current validated shape

- Binary focus: non-interactive `run`
- Commands retained in headless surface:
  - `dirs`
  - `models`
  - `run`
- Headless guards:
  - rejects `CRUSH_CLIENT_SERVER=1`
  - rejects MCP-configured non-interactive runs

## Build on the target

From the `riscv64` target host:

```bash
cd /home/pi/crush-riscv64
./build-headless-riscv64.sh /home/pi/crush-riscv64/forks/crush crush-headless-riscv64
```

Expected result:

- binary written to `/home/pi/crush-riscv64/forks/crush/crush-headless-riscv64`
- current builds may be static; the build script will say whether an ELF
  interpreter exists

## Package into dist

```bash
cd /home/pi/crush-riscv64
./package-headless-riscv64.sh /home/pi/crush-riscv64/forks/crush crush-headless-riscv64 /home/pi/crush-riscv64/dist
```

Expected result:

- binary copied into `/home/pi/crush-riscv64/dist/`
- optional SHA256 file generated when `sha256sum` is available

## Minimal config

Use the prepared DeepSeek-compatible config template:

```bash
mkdir -p ~/.config/crush
cp /home/pi/crush-riscv64/crush-deepseek.config.json ~/.config/crush/crush.json
export DEEPSEEK_API_KEY="your-key"
```

## Smoke test

```bash
cd /home/pi/crush-riscv64/forks/crush
DEEPSEEK_API_KEY="your-key" ./crush-headless-riscv64 run "Reply with exactly: HEADLESS_SMOKE_OK" </dev/null
```

Or use the wrapper:

```bash
cd /home/pi/crush-riscv64
DEEPSEEK_API_KEY="your-key" ./test-headless-riscv64.sh /home/pi/crush-riscv64/forks/crush/crush-headless-riscv64
```

## Notes

- The validated target machine in this project is `pi-board` at
  `192.168.137.223`.
- The current headless artifact is intentionally small and excludes interactive
  TUI flows and several non-core operational commands.
- If the binary reports provider auth errors, verify the `DEEPSEEK_API_KEY`
  export in the shell where you invoke it.
