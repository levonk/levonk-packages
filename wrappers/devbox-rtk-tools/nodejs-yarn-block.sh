#!/usr/bin/env bash
# Combines: environment management (devbox) + token optimization (RTK) + tool governance (block npm/pnpm)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "$SCRIPT_DIR/utils/devbox-manager.sh"
fi
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

# Governance: Block npm/pnpm
case "$(basename "$0")" in
    npm|pnpm)
        echo "❌ $(basename "$0") is blocked by policy. Use yarn instead."
        echo "💡 Install yarn: https://yarnpkg.com/getting-started/install"
        exit 1
        ;;
esac

# Environment management + RTK optimization for yarn
devbox_wrap yarn "$@"