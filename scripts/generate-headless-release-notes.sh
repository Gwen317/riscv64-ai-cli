#!/usr/bin/env bash
set -euo pipefail

bundle_dir="${1:?bundle directory required}"
output_path="${2:-$bundle_dir/RELEASE_NOTES.md}"
manifest_path="$bundle_dir/manifest.json"

if [[ ! -f "$manifest_path" ]]; then
  echo "manifest not found: $manifest_path" >&2
  exit 1
fi

python3 - "$manifest_path" "$output_path" <<'PY'
import json
import pathlib
import sys

manifest_path = pathlib.Path(sys.argv[1])
output_path = pathlib.Path(sys.argv[2])
data = json.loads(manifest_path.read_text(encoding="utf-8"))

artifact = data.get("artifact_name", "unknown-artifact")
commit = data.get("upstream_commit", "unknown")
commands = data.get("validated_commands", [])
non_goals = data.get("non_goals", [])
target_os = data.get("target_os", "linux")
target_arch = data.get("target_arch", "riscv64")

lines = [
    "# Headless Release Notes",
    "",
    "## Summary",
    "",
    f"- Artifact: `{artifact}`",
    f"- Target: `{target_os}/{target_arch}`",
    f"- Upstream commit: `{commit}`",
    "",
    "## Included Command Surface",
    "",
]
lines.extend([f"- `{cmd}`" for cmd in commands] or ["- none recorded"])
lines.extend([
    "",
    "## Known Limits",
    "",
])
lines.extend([f"- {item}" for item in non_goals] or ["- none recorded"])
lines.extend([
    "",
    "## Bundle Files",
    "",
])
for path in sorted(p.name for p in manifest_path.parent.iterdir() if p.is_file()):
    lines.append(f"- `{path}`")

lines.extend([
    "",
    "## Validation",
    "",
    "- Bundle generated successfully.",
    "- Provider-backed smoke should be recorded in the accompanying runtime notes or pipeline log.",
    "",
    "## Notes",
    "",
    "- This release notes file was generated from `manifest.json`.",
])

output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
print(output_path)
PY
