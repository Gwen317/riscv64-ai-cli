#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
src_dir="${1:-$(cd "$repo_root/forks/crush" && pwd)}"
dist_dir="${2:-$repo_root/dist}"
headless_artifact="${3:-crush-headless-full-pipeline}"
interactive_artifact="${4:-crush-interactive-full-pipeline}"
headless_token="${5:-HEADLESS_FULL_PIPELINE_OK}"
interactive_token="${6:-INTERACTIVE_FULL_PIPELINE_OK}"
timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
run_dir="$dist_dir/full-pipeline-runs/$timestamp"
log_path="$run_dir/full-pipeline.log"

if [[ -z "${DEEPSEEK_API_KEY:-}" ]]; then
  echo "DEEPSEEK_API_KEY is required for full pipeline execution." >&2
  exit 1
fi

mkdir -p "$run_dir"

{
  echo "FULL_PIPELINE_STARTED=$timestamp"
  "$repo_root/scripts/run-headless-pipeline.sh" "$src_dir" "$headless_artifact" "$dist_dir" "$headless_token"
  "$repo_root/scripts/verify-interactive-riscv64.sh" "$src_dir" "$interactive_artifact" "$interactive_token" "/tmp/interactive-full-pipeline-$timestamp"
  echo "FULL_PIPELINE_HEADLESS_ARTIFACT=$dist_dir/${headless_artifact}-bundle/$headless_artifact"
  echo "FULL_PIPELINE_INTERACTIVE_ARTIFACT=$src_dir/$interactive_artifact"
  echo "FULL_PIPELINE_HEADLESS_TOKEN=$headless_token"
  echo "FULL_PIPELINE_INTERACTIVE_TOKEN=$interactive_token"
} 2>&1 | tee "$log_path"

echo "FULL_PIPELINE_LOG=$log_path"
