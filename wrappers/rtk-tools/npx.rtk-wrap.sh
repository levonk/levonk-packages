#!/usr/bin/env sh
# RTK wrapper for npx command
# Transparently runs npx through RTK for intelligent routing

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap npx npx "intelligent routing"