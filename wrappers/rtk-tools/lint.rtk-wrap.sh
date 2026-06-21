#!/usr/bin/env sh
# RTK wrapper for lint command
# Transparently runs lint through RTK for grouped rule violations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap lint lint "grouped rule violations"