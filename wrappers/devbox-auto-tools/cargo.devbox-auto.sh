#!/usr/bin/env sh
# Devbox auto-wrapper for cargo
# Automatically ensures cargo is available via devbox before execution

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "$SCRIPT_DIR/utils/devbox-manager.sh"
fi

devbox_wrap cargo "$@"