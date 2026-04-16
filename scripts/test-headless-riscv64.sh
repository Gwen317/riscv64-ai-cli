#!/usr/bin/env bash
set -euo pipefail

bin_path="${1:-./crush-headless-riscv64}"
expected_text="${2:-HEADLESS_SMOKE_OK}"

if [[ ! -x "$bin_path" ]]; then
  echo "binary not executable: $bin_path" >&2
  exit 1
fi

echo "[1/4] version"
"$bin_path" --version

echo "[2/4] help"
"$bin_path" --help >/dev/null

echo "[3/4] dirs"
"$bin_path" dirs

if [[ -z "${DEEPSEEK_API_KEY:-}" ]]; then
  echo "[4/4] skipped provider-backed smoke: DEEPSEEK_API_KEY is not set"
  exit 0
fi

echo "[4/4] provider-backed run"
output="$("$bin_path" run "Reply with exactly: ${expected_text}" </dev/null)"
echo "$output"
if [[ "$output" != *"$expected_text"* ]]; then
  echo "unexpected output: expected token ${expected_text}" >&2
  exit 1
fi
