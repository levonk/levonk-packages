#!/usr/bin/env bash
# RTK wrapper for aws command
# Transparently runs aws through RTK for compact output (force JSON, compress)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap aws aws "compact output (force JSON, compress)"