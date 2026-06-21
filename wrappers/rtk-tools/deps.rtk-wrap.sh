#!/usr/bin/env sh
# RTK wrapper for deps command
# Transparently runs deps through RTK to summarize project dependencies

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap deps deps "summarize project dependencies"