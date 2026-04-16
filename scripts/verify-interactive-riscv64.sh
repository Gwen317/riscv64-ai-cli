#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$script_dir"
src_dir="${1:-$(cd "$repo_root/forks/crush" && pwd)}"
artifact_name="${2:-crush-interactive-verify}"
smoke_token="${3:-INTERACTIVE_VERIFY_OK}"
workdir="${4:-/tmp/interactive-verify}"

if [[ -z "${DEEPSEEK_API_KEY:-}" ]]; then
  echo "DEEPSEEK_API_KEY is required for interactive verification." >&2
  exit 1
fi

"$repo_root/build-interactive-riscv64.sh" "$src_dir" "$artifact_name"
python3 "$repo_root/test-interactive-riscv64.py" "$src_dir/$artifact_name" "$smoke_token" "$workdir"

echo "VERIFIED_INTERACTIVE_ARTIFACT=$src_dir/$artifact_name"
echo "VERIFIED_INTERACTIVE_SMOKE_TOKEN=$smoke_token"
