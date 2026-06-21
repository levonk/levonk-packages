#!/usr/bin/env bash
# RTK wrapper for psql command
# Transparently runs psql through RTK for compact output (strip borders, compress tables)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap psql psql "compact output (strip borders, compress tables)"