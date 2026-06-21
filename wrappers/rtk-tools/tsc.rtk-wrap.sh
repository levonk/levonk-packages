#!/usr/bin/env bash
# RTK wrapper for tsc command
# Transparently runs tsc through RTK for grouped error output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap tsc tsc "grouped error output"