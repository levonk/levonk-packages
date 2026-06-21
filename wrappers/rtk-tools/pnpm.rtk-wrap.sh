#!/usr/bin/env bash
# RTK wrapper for pnpm command
# Transparently runs pnpm through RTK for ultra-compact output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap pnpm pnpm "ultra-compact output"