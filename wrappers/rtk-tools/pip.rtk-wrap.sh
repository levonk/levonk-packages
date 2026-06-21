#!/usr/bin/env sh
# RTK wrapper for pip command
# Transparently runs pip through RTK for compact output (auto-detects uv)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap pip pip "compact output"