#!/usr/bin/env sh
# RTK wrapper for err command
# Transparently runs err through RTK to show only errors/warnings

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap err err "show only errors/warnings"