#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src_dir="${1:-$(cd "$script_dir/forks/crush" && pwd)}"
out_name="${2:-crush-headless-riscv64}"

BUILD_TAGS=headless "$script_dir/build-riscv64.sh" "$src_dir" "$out_name"
