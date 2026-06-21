#!/usr/bin/env sh
# Integrated devbox + RTK wrapper for Node.js with native tools (no governance)
# Combines: environment management (devbox) + token optimization (RTK) + native tool usage

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "$SCRIPT_DIR/utils/devbox-manager.sh"
fi
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

# No governance - use tools as-is
# Environment management + RTK optimization for called tool
devbox_wrap "$(basename "$0")" "$@"