#!/usr/bin/env bash
set -euo pipefail

bin_path="${1:-./crush-riscv64}"

if [[ ! -x "$bin_path" ]]; then
  echo "binary not executable: $bin_path" >&2
  exit 1
fi

"$bin_path" --version
"$bin_path" dirs

set +e
timeout 20s "$bin_path" run hello </dev/null
run_code=$?
set -e

echo "run exit code: $run_code"
if [[ "$run_code" -ne 0 ]]; then
  echo "non-interactive run did not complete successfully; inspect provider/config state"
fi
