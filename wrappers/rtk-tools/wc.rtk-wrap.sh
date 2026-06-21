#!/usr/bin/env bash
# RTK wrapper for wc command
# Transparently runs wc through RTK for compact output (strips paths and padding)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap wc wc "compact output"