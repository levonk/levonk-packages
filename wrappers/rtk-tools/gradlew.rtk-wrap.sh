#!/usr/bin/env bash
# RTK wrapper for gradlew command
# Transparently runs gradlew through RTK for compact Android build output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap gradlew gradlew "compact Android build output"