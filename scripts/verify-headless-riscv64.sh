#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$script_dir"
src_dir="${1:-$(cd "$repo_root/forks/crush" && pwd)}"
artifact_name="${2:-crush-headless-verify}"
dist_dir="${3:-$repo_root/dist}"
smoke_token="${4:-HEADLESS_VERIFY_OK}"

if [[ -z "${DEEPSEEK_API_KEY:-}" ]]; then
  echo "DEEPSEEK_API_KEY is required for provider-backed verification." >&2
  exit 1
fi

"$repo_root/build-headless-riscv64.sh" "$src_dir" "$artifact_name"
"$repo_root/package-headless-riscv64.sh" "$src_dir" "$artifact_name" "$dist_dir"
"$repo_root/test-headless-riscv64.sh" "$dist_dir/$artifact_name" "$smoke_token"

echo "VERIFIED_ARTIFACT=$dist_dir/$artifact_name"
echo "VERIFIED_SMOKE_TOKEN=$smoke_token"
