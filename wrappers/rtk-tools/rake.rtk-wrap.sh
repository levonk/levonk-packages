#!/usr/bin/env bash
# RTK wrapper for rake command
# Transparently runs rake through RTK for compact minitest output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap rake rake "compact minitest output"