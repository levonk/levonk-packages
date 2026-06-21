#!/usr/bin/env bash
# Combines: environment management (devbox) + token optimization (RTK) + tool governance (block pip)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "$SCRIPT_DIR/utils/devbox-manager.sh"
fi
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

# Governance: Block pip
if [ "$(basename "$0")" = "pip" ]; then
    echo "❌ pip is blocked by policy. Use uv instead."
    echo "💡 Install uv: https://github.com/astral-sh/uv"
    exit 1
fi

# Environment management + RTK optimization for uv
devbox_wrap uv "$@"