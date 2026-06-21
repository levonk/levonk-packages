#!/usr/bin/env sh
# RTK wrapper for oc command
# Transparently runs oc through RTK for compact OpenShift output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap oc oc "compact OpenShift output"