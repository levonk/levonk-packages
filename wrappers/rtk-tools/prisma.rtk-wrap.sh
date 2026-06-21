#!/usr/bin/env bash
# RTK wrapper for prisma command
# Transparently runs prisma through RTK for compact output (no ASCII art)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap prisma prisma "compact output (no ASCII art)"