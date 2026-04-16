#!/usr/bin/env bash
set -euo pipefail

bin_path="${1:-./crush-interactive-riscv64}"
shift || true

if [[ ! -f "$bin_path" ]]; then
  echo "binary not found: $bin_path" >&2
  exit 1
fi

export TERM="${TERM:-xterm-256color}"

# On the target board, invoking the loader explicitly is more reliable than
# executing the binary directly from some shells.
exec /lib/ld-linux-riscv64-lp64d.so.1 "$bin_path" "$@"
