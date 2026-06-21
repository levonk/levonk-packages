#!/usr/bin/env bash
# RTK wrapper for diff command
# Transparently runs diff through RTK for ultra-condensed output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap diff diff "ultra-condensed output"