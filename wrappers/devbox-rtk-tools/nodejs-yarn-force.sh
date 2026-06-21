#!/usr/bin/env bash
# Combines: environment management (devbox) + token optimization (RTK) + tool governance (force npm/pnpm→yarn)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "$SCRIPT_DIR/utils/devbox-manager.sh"
fi
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

# Governance: Force npm/pnpm → yarn
case "$(basename "$0")" in
    npm|pnpm)
        echo "✅ Using yarn instead of $(basename "$0") (forced by policy)..."
        set -- yarn "$@"
        ;;
esac

# Environment management + RTK optimization for yarn
devbox_wrap yarn "$@"