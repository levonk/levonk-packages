#!/usr/bin/env sh
# RTK wrapper for curl command
# Transparently runs curl through RTK for auto-JSON detection and schema output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap curl curl "auto-JSON detection and schema output"