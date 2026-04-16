#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
src_dir="${1:-$(cd "$repo_root/forks/crush" && pwd)}"
artifact_name="${2:-crush-headless-riscv64}"
dist_dir="${3:-$repo_root/dist}"

mkdir -p "$dist_dir"

"$script_dir/build-headless-riscv64.sh" "$src_dir" "$artifact_name"

src_bin="$src_dir/$artifact_name"
dst_bin="$dist_dir/$artifact_name"
cp "$src_bin" "$dst_bin"

if command -v sha256sum >/dev/null 2>&1; then
  (cd "$dist_dir" && sha256sum "$artifact_name" > "$artifact_name.sha256")
fi

echo "PACKAGED=$dst_bin"
