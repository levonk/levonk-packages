#!/usr/bin/env sh
# RTK Wrapper Utility
# Centralized logic for RTK command wrapping
# Usage: source this script, then call rtk_wrap <native_cmd> <rtk_subcommand> [description] -- <script_args...>
#
# native_cmd may be:
#   - An absolute path (e.g. /nix/store/.../bin/git) — exec'd directly, no PATH lookup.
#   - A bare command name (e.g. "eslint") — resolved via PATH excluding this
#     script's own directory, to avoid infinite recursion when the wrapper
#     itself is in PATH.

# Resolve the real native binary, avoiding recursion.
# For bare names: exclude this script's directory from PATH so command -v
# skips the wrapper itself and finds the real binary (e.g. in node_modules/.bin).
_rtk_resolve_native() {
    local native_cmd="$1"
    case "$native_cmd" in
        /*)
            # Absolute path — use as-is
            printf '%s' "$native_cmd"
            return 0
            ;;
    esac
    # Bare name — try PATH with our own directory excluded
    local _wrapper_dir
    _wrapper_dir="$(cd "$(dirname "$0")" 2>/dev/null && pwd)"
    if [ -n "$_wrapper_dir" ]; then
        local _clean_path
        _clean_path="$PATH"
        # Remove wrapper dir from PATH (handle start, middle, end positions)
        _clean_path="${_clean_path#"$_wrapper_dir:"}"
        _clean_path="${_clean_path%":$_wrapper_dir"}"
        _clean_path="${_clean_path//":$_wrapper_dir:"/:}"  # ponytail: naive single-pass replace; if wrapper dir appears 2+ times in PATH, later copies remain. Upgrade: use IFS loop.
        local _found
        _found="$(PATH="$_clean_path" command -v "$native_cmd" 2>/dev/null)" || true
        if [ -n "$_found" ]; then
            printf '%s' "$_found"
            return 0
        fi
    fi
    # Last resort: return the bare name and let exec try PATH
    printf '%s' "$native_cmd"
}

rtk_wrap() {
    local native_cmd="$1"
    local rtk_subcommand="${2:-$1}"
    local description="${3:-token-optimized output}"
    shift 3
    # "$@" now contains the script's original arguments (passed after the 3 fixed args)

    # Resolve the real native binary (absolute path or PATH-excluded lookup)
    local real_bin
    real_bin="$(_rtk_resolve_native "$native_cmd")"

    # Check if we're already being called by RTK to prevent infinite recursion
    # If RTK is calling this wrapper, just execute the native command directly
    if [ -n "${RTK_WRAPPER_IN_PROGRESS:-}" ]; then
        exec "$real_bin" "$@"
    fi

    # Check if RTK is available
    if command -v rtk >/dev/null 2>&1; then
        # Run through RTK with marker to prevent recursion
        export RTK_WRAPPER_IN_PROGRESS=1
        exec rtk "$rtk_subcommand" "$@"
    else
        # Fallback to native command if RTK not installed
        echo "⚠️ RTK not found, using native $native_cmd. Install RTK for $description." >&2
        exec "$real_bin" "$@"
    fi
}