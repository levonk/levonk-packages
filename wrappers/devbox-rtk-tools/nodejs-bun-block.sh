#!/usr/bin/env sh
# Integrated devbox + RTK + governance wrapper for Node.js with npm/pnpm/yarn blocked
# Combines: environment management (devbox) + token optimization (RTK) + tool governance (block npm/pnpm/yarn)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "$SCRIPT_DIR/utils/devbox-manager.sh"
fi
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

# Governance: Block npm/pnpm/yarn
case "$(basename "$0")" in
    npm|pnpm|yarn)
        echo "❌ $(basename "$0") is blocked by policy. Use bun instead."
        echo "💡 Install bun: https://bun.sh/docs/installation"
        exit 1
        ;;
esac

# Environment management + RTK optimization for bun
devbox_wrap bun "$@"