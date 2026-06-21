#!/usr/bin/env bash
# RTK wrapper for gt command
# Transparently runs gt through RTK for compact stacked PR output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap gt gt "compact stacked PR output"