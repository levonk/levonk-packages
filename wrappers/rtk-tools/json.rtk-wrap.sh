#!/usr/bin/env sh
# RTK wrapper for json command
# Transparently runs json through RTK for compact values (or keys-only with --keys-only)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap json json "compact values"