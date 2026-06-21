#!/usr/bin/env bash
# RTK wrapper for env command
# Transparently runs env through RTK for filtered output (sensitive masked)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap env env "filtered output (sensitive masked)"