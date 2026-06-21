#!/usr/bin/env bash
# Combines: environment management (devbox) + token optimization (RTK) + tool governance (block npm)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "$SCRIPT_DIR/utils/devbox-manager.sh"
fi
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

# Governance: Block npm
if [ "$(basename "$0")" = "npm" ]; then
    echo "❌ npm is blocked by policy. Use pnpm instead."
    echo "💡 Install pnpm: https://pnpm.io/installation"
    exit 1
fi

# Environment management + RTK optimization for pnpm
devbox_wrap pnpm "$@"