#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$script_dir"
scripts_dir="$repo_root/scripts"
src_dir="${1:-$(cd "$repo_root/forks/crush" && pwd)}"
artifact_name="${2:-crush-headless-riscv64}"
dist_dir="${3:-$repo_root/dist}"
bundle_dir="$dist_dir/${artifact_name}-bundle"
config_template="$scripts_dir/crush-deepseek.config.json"

if [[ ! -f "$config_template" ]]; then
  config_template="$repo_root/crush-deepseek.config.json"
fi

mkdir -p "$bundle_dir"

"$script_dir/package-headless-riscv64.sh" "$src_dir" "$artifact_name" "$bundle_dir"

cp "$repo_root/docs/guides/HEADLESS_DEPLOY.md" "$bundle_dir/"
cp "$repo_root/docs/guides/HEADLESS_RELEASE.md" "$bundle_dir/"
cp "$config_template" "$bundle_dir/crush-deepseek.config.json"

for optional_file in \
  "$repo_root/docs/notes/build-log.md" \
  "$repo_root/docs/notes/runtime-test.md" \
  "$repo_root/docs/notes/decisions.md"
do
  if [[ -f "$optional_file" ]]; then
    cp "$optional_file" "$bundle_dir/"
  fi
done

if command -v git >/dev/null 2>&1; then
  (
    cd "$src_dir"
    git rev-parse HEAD > "$bundle_dir/UPSTREAM_COMMIT.txt"
  )
fi

commit_value="unknown"
if [[ -f "$bundle_dir/UPSTREAM_COMMIT.txt" ]]; then
  commit_value="$(tr -d '\r\n' < "$bundle_dir/UPSTREAM_COMMIT.txt")"
fi

cat > "$bundle_dir/manifest.json" <<EOF
{
  "artifact_name": "${artifact_name}",
  "bundle_dir": "${bundle_dir}",
  "target_os": "linux",
  "target_arch": "riscv64",
  "binary": "${artifact_name}",
  "validated_commands": ["dirs", "models", "run"],
  "non_goals": [
    "interactive TUI",
    "login flow",
    "client/server mode",
    "MCP-enabled headless runs",
    "LSP-default-enriched headless config behavior"
  ],
  "upstream_commit": "${commit_value}"
}
EOF

if command -v tar >/dev/null 2>&1; then
  (
    cd "$dist_dir"
    tar -czf "${artifact_name}-bundle.tar.gz" "${artifact_name}-bundle"
  )
fi

echo "RELEASE_BUNDLE=$bundle_dir"
