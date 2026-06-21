#!/usr/bin/env bash
# Combines: environment management (devbox) + token optimization (RTK) + tool governance (force npm→pnpm)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "$SCRIPT_DIR/utils/devbox-manager.sh"
fi
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

# Governance: Force npm → pnpm
if [ "$(basename "$0")" = "npm" ]; then
    echo "✅ Using pnpm instead of npm (forced by policy)..."
    set -- pnpm "$@"
fi

# Environment management + RTK optimization for pnpm
devbox_wrap pnpm "$@"