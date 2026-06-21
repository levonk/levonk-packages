#!/usr/bin/env sh
# Integrated devbox + RTK + governance wrapper for Node.js with bun preferred
# Combines: environment management (devbox) + token optimization (RTK) + tool governance (prefer npm/pnpm/yarn→bun)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "$SCRIPT_DIR/utils/devbox-manager.sh"
fi
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

# Governance: Prefer npm/pnpm/yarn → bun
case "$(basename "$0")" in
    npm|pnpm|yarn)
        echo "⚠️ Prefer bun over $(basename "$0"). Using bun..."
        set -- bun "$@"
        ;;
esac

# Environment management + RTK optimization for bun
devbox_wrap bun "$@"