#!/usr/bin/env bash
set -euo pipefail

src_dir="${1:-$(pwd)}"
out_name="${2:-crush-riscv64}"
elf_interp="${ELF_INTERP_PATH:-/lib/ld-linux-riscv64-lp64d.so.1}"
build_tags="${BUILD_TAGS:-}"

cd "$src_dir"

export CGO_ENABLED="${CGO_ENABLED:-0}"
export GOTOOLCHAIN="${GOTOOLCHAIN:-auto}"
unset GOEXPERIMENT

if [[ -n "$build_tags" ]]; then
  GOOS=linux GOARCH=riscv64 go build -tags "$build_tags" ./...
  GOOS=linux GOARCH=riscv64 go build -tags "$build_tags" -ldflags="-I ${elf_interp}" -o "$out_name" .
else
  GOOS=linux GOARCH=riscv64 go build ./...
  GOOS=linux GOARCH=riscv64 go build -ldflags="-I ${elf_interp}" -o "$out_name" .
fi

echo "OUTPUT=$out_name"
file "$out_name"
if ! readelf -l "$out_name" | grep interpreter -A1; then
  echo "No ELF interpreter entry (likely static binary)."
fi
