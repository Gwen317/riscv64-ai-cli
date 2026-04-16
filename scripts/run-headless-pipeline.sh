#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$script_dir"
src_dir="${1:-$(cd "$repo_root/forks/crush" && pwd)}"
artifact_name="${2:-crush-headless-pipeline}"
dist_dir="${3:-$repo_root/dist}"
smoke_token="${4:-HEADLESS_PIPELINE_OK}"
timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
run_dir="$dist_dir/pipeline-runs/$timestamp"
log_path="$run_dir/pipeline.log"

if [[ -z "${DEEPSEEK_API_KEY:-}" ]]; then
  echo "DEEPSEEK_API_KEY is required for pipeline execution." >&2
  exit 1
fi

mkdir -p "$run_dir"

{
  echo "PIPELINE_STARTED=$timestamp"
  "$repo_root/release-headless-riscv64.sh" "$src_dir" "$artifact_name" "$dist_dir"
  "$repo_root/test-headless-riscv64.sh" "$dist_dir/${artifact_name}-bundle/$artifact_name" "$smoke_token"
  "$repo_root/generate-headless-release-notes.sh" "$dist_dir/${artifact_name}-bundle"
  echo "PIPELINE_ARTIFACT=$dist_dir/${artifact_name}-bundle/$artifact_name"
  echo "PIPELINE_BUNDLE=$dist_dir/${artifact_name}-bundle"
  echo "PIPELINE_SMOKE_TOKEN=$smoke_token"
} 2>&1 | tee "$log_path"

echo "PIPELINE_LOG=$log_path"
