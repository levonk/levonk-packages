#!/usr/bin/env sh
# Integrated devbox + RTK + governance wrapper for Python with uv forced
# Combines: environment management (devbox) + token optimization (RTK) + tool governance (force pip→uv)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "$SCRIPT_DIR/utils/devbox-manager.sh"
fi
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

# Governance: Force pip → uv
if [ "$(basename "$0")" = "pip" ]; then
    echo "✅ Using uv instead of pip (forced by policy)..."
    set -- uv "$@"
fi

# Environment management + RTK optimization for uv
devbox_wrap uv "$@"