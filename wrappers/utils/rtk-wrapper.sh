#!/usr/bin/env sh
# RTK Wrapper Utility
# Centralized logic for RTK command wrapping
# Usage: source this script, then call rtk_wrap <native_cmd> <rtk_subcommand> [description]

rtk_wrap() {
    local native_cmd="$1"
    local rtk_subcommand="${2:-$1}"
    local description="${3:-token-optimized output}"
    
    # Check if we're already being called by RTK to prevent infinite recursion
    # If RTK is calling this wrapper, just execute the native command directly
    if [ -n "${RTK_WRAPPER_IN_PROGRESS:-}" ]; then
        exec "$native_cmd" "$@"
    fi
    
    # Check if RTK is available
    if command -v rtk >/dev/null 2>&1; then
        # Run through RTK with marker to prevent recursion
        export RTK_WRAPPER_IN_PROGRESS=1
        exec rtk "$rtk_subcommand" "$@"
    else
        # Fallback to native command if RTK not installed
        echo "⚠️ RTK not found, using native $native_cmd. Install RTK for $description."
        exec "$native_cmd" "$@"
    fi
}