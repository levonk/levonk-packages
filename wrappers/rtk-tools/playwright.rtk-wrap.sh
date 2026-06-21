#!/usr/bin/env bash
# RTK wrapper for playwright command
# Transparently runs playwright through RTK for compact E2E test output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap playwright playwright "compact E2E test output"