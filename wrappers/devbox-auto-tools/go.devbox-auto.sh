#!/usr/bin/env sh
# Devbox auto-wrapper for go
# Automatically ensures go is available via devbox before execution

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "$SCRIPT_DIR/utils/devbox-manager.sh"
fi

devbox_wrap go "$@"