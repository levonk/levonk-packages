#!/usr/bin/env sh
# Integrated devbox + RTK + governance wrapper for Node.js with yarn preferred
# Combines: environment management (devbox) + token optimization (RTK) + tool governance (prefer npm/pnpm→yarn)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "$SCRIPT_DIR/utils/devbox-manager.sh"
fi
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

# Governance: Prefer npm/pnpm → yarn
case "$(basename "$0")" in
    npm|pnpm)
        echo "⚠️ Prefer yarn over $(basename "$0"). Using yarn..."
        set -- yarn "$@"
        ;;
esac

# Environment management + RTK optimization for yarn
devbox_wrap yarn "$@"