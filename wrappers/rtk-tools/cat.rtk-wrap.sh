#!/usr/bin/env bash
# RTK wrapper for cat command (uses rtk read)
# Transparently runs cat through RTK read for token-optimized output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap cat read "intelligent file filtering"