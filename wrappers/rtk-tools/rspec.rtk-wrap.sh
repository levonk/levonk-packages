#!/usr/bin/env sh
# RTK wrapper for rspec command
# Transparently runs rspec through RTK for compact JSON output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap rspec rspec "compact JSON output"