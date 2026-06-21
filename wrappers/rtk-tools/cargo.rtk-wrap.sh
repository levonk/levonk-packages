#!/usr/bin/env bash
# RTK wrapper for cargo command
# Transparently runs cargo through RTK for compact output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap cargo cargo "compact output"