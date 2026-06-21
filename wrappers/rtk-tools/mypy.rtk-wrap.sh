#!/usr/bin/env bash
# RTK wrapper for mypy command
# Transparently runs mypy through RTK for grouped error output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap mypy mypy "grouped error output"