#!/usr/bin/env bash

# Remote board access
export RISCV64_HOST="pi-board"
export RISCV64_WORKDIR="/home/pi/crush-riscv64/forks/crush"

# Optional build override
export ELF_INTERP_PATH="/lib/ld-linux-riscv64-lp64d.so.1"

# Example provider settings for later runtime validation
# export OPENAI_API_KEY="..."
# export OPENAI_BASE_URL="https://..."
# export ANTHROPIC_API_KEY="..."
