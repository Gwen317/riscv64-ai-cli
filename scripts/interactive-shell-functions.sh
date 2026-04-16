#!/usr/bin/env bash

# Source this file in an interactive shell on the target board:
#   source /home/pi/crush-riscv64/interactive-shell-functions.sh

export CRUSH_RISCV64_ROOT="${CRUSH_RISCV64_ROOT:-/home/pi/crush-riscv64}"
export CRUSH_RISCV64_SRC="${CRUSH_RISCV64_SRC:-$CRUSH_RISCV64_ROOT/forks/crush}"

crushi-build() {
  "$CRUSH_RISCV64_ROOT/build-interactive-riscv64.sh" "$CRUSH_RISCV64_SRC" "${1:-crush-interactive-riscv64}"
}

crushi-run() {
  "$CRUSH_RISCV64_ROOT/run-interactive-riscv64.sh" "$CRUSH_RISCV64_SRC/${1:-crush-interactive-riscv64}"
}

crushi-verify() {
  "$CRUSH_RISCV64_ROOT/verify-interactive-riscv64.sh" "$CRUSH_RISCV64_SRC" "${1:-crush-interactive-verify}" "${2:-INTERACTIVE_VERIFY_OK}" "${3:-/tmp/interactive-verify}"
}

crushh-run() {
  "$CRUSH_RISCV64_ROOT/dist/crush-headless-release-bundle/crush-headless-release" run "${1:-hello}" </dev/null
}
