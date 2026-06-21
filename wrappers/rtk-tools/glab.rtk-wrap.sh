#!/usr/bin/env sh
# RTK wrapper for glab command
# Transparently runs glab through RTK for token-optimized output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap glab glab "token-optimized output"