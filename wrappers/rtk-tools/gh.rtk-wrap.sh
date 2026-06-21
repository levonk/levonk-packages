#!/usr/bin/env bash
# RTK wrapper for gh (GitHub CLI) command
# Transparently runs gh through RTK for token-optimized output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap gh gh "token-optimized output"