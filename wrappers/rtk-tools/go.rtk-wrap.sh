#!/usr/bin/env bash
# RTK wrapper for go command
# Transparently runs go through RTK for compact output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap go go "compact output"