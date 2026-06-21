#!/usr/bin/env sh
# Integrated devbox + RTK + governance wrapper for Node.js with pnpm preferred
# Combines: environment management (devbox) + token optimization (RTK) + tool governance (prefer npm→pnpm)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "$SCRIPT_DIR/utils/devbox-manager.sh"
fi
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

# Governance: Prefer npm → pnpm
if [ "$(basename "$0")" = "npm" ]; then
    echo "⚠️ Prefer pnpm over npm. Using pnpm..."
    set -- pnpm "$@"
fi

# Environment management + RTK optimization for pnpm
devbox_wrap pnpm "$@"