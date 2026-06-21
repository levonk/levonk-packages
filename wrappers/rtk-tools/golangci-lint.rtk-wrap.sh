#!/usr/bin/env bash
# RTK wrapper for golangci-lint command
# Transparently runs golangci-lint through RTK for compact run support

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap golangci-lint golangci-lint "compact run support"