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

crushi-start() {
  local bin="${1:-crush-interactive-riscv64}"
  shift || true
  "$CRUSH_RISCV64_ROOT/run-interactive-riscv64.sh" "$CRUSH_RISCV64_SRC/$bin" "$@"
}

crushi-here() {
  local bin="${1:-crush-interactive-riscv64}"
  "$CRUSH_RISCV64_ROOT/run-interactive-riscv64.sh" "$CRUSH_RISCV64_SRC/$bin" --cwd "$(pwd)"
}

crushi-verify() {
  "$CRUSH_RISCV64_ROOT/verify-interactive-riscv64.sh" "$CRUSH_RISCV64_SRC" "${1:-crush-interactive-verify}" "${2:-INTERACTIVE_VERIFY_OK}" "${3:-/tmp/interactive-verify}"
}

crushi-continue() {
  local bin="${1:-crush-interactive-riscv64}"
  shift || true
  "$CRUSH_RISCV64_ROOT/run-interactive-riscv64.sh" "$CRUSH_RISCV64_SRC/$bin" --continue "$@"
}

crushi-session() {
  local session_id="${1:?session id required}"
  local bin="${2:-crush-interactive-riscv64}"
  "$CRUSH_RISCV64_ROOT/run-interactive-riscv64.sh" "$CRUSH_RISCV64_SRC/$bin" --session "$session_id"
}

crushh-run() {
  "$CRUSH_RISCV64_ROOT/dist/crush-headless-release-bundle/crush-headless-release" run "${1:-hello}" </dev/null
}

crushh-continue() {
  "$CRUSH_RISCV64_ROOT/dist/crush-headless-release-bundle/crush-headless-release" run --continue "${1:-continue}" </dev/null
}
