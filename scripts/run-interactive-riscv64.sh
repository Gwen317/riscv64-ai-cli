#!/usr/bin/env bash
set -euo pipefail

bin_path="${1:-./crush-interactive-riscv64}"
shift || true

if [[ ! -f "$bin_path" ]]; then
  echo "binary not found: $bin_path" >&2
  exit 1
fi

if [[ ! -t 0 || ! -t 1 ]]; then
  echo "interactive mode requires a real terminal on stdin and stdout." >&2
  echo "Use this wrapper from a normal SSH terminal instead of redirected or piped input." >&2
  exit 1
fi

export TERM="${TERM:-xterm-256color}"

# On the target board, invoking the loader explicitly is more reliable than
# executing the binary directly from some shells.
exec /lib/ld-linux-riscv64-lp64d.so.1 "$bin_path" "$@"
