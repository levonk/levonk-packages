#!/usr/bin/env sh
# RTK Wrapper Utility
# Centralized logic for RTK command wrapping
# Usage: source this script, then call rtk_wrap <native_cmd> <rtk_subcommand> [description] -- <script_args...>
#
# Set RTK_ONLY=1 before calling rtk_wrap for RTK-specific commands that have
# no native equivalent (err, json, deps, lint, format, etc.). The wrapper IS
# the command — it always runs through RTK and fails clearly if RTK is absent.
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

# Resolve the rtk binary itself, preferring an upstream install over the
# nixpkgs fallback baked in at build time.
# 1. Look for rtk on PATH excluding this wrapper's own directory (finds user's
#    upstream install — github:rtk-ai/rtk, manual build, etc. — never the
#    nixpkgs copy that might share the bundle's store path).
# 2. If not found, fall back to RTK_FALLBACK (absolute store path set at build
#    time by the Nix lib, pointing to nixpkgs rtk).
# 3. If neither, return failure so the caller can warn / fall back to native.
_rtk_resolve_rtk() {
    local _wrapper_dir
    _wrapper_dir="$(cd "$(dirname "$0")" 2>/dev/null && pwd)"
    if [ -n "$_wrapper_dir" ]; then
        local _clean_path="$PATH"
        _clean_path="${_clean_path#"$_wrapper_dir:"}"
        _clean_path="${_clean_path%":$_wrapper_dir"}"
        _clean_path="${_clean_path//":$_wrapper_dir:"/:}"
        local _found
        _found="$(PATH="$_clean_path" command -v rtk 2>/dev/null)" || true
        if [ -n "$_found" ]; then
            printf '%s' "$_found"
            return 0
        fi
    fi
    if [ -n "${RTK_FALLBACK:-}" ] && [ -x "${RTK_FALLBACK}" ]; then
        printf '%s' "$RTK_FALLBACK"
        return 0
    fi
    return 1
}

rtk_wrap() {
    local native_cmd="$1"
    local rtk_subcommand="${2:-$1}"
    local description="${3:-token-optimized output}"
    shift 3
    # "$@" now contains the script's original arguments (passed after the 3 fixed args)

    # RTK_ONLY commands have no native fallback — the wrapper IS the command
    if [[ "${RTK_ONLY:-0}" -eq 1 ]]; then
        if [ -n "${RTK_WRAPPER_IN_PROGRESS:-}" ]; then
            echo "❌ $rtk_subcommand is an RTK-only command but RTK called back into the wrapper (recursion). Aborting." >&2
            exit 1
        fi
        local _rtk_bin
        if _rtk_bin="$(_rtk_resolve_rtk)"; then
            export RTK_WRAPPER_IN_PROGRESS=1
            exec "$_rtk_bin" "$rtk_subcommand" "$@"
        else
            echo "❌ $rtk_subcommand requires RTK to be installed. This is an RTK-specific command with no native fallback." >&2
            echo "   Install RTK: https://github.com/rtk-ai/rtk" >&2
            exit 1
        fi
    fi

    # Resolve the real native binary (absolute path or PATH-excluded lookup)
    local real_bin
    real_bin="$(_rtk_resolve_native "$native_cmd")"

    # Check if we're already being called by RTK to prevent infinite recursion
    # If RTK is calling this wrapper, just execute the native command directly
    if [ -n "${RTK_WRAPPER_IN_PROGRESS:-}" ]; then
        exec "$real_bin" "$@"
    fi

    # Resolve rtk: prefer upstream install, fall back to bundled nixpkgs copy
    local _rtk_bin
    if _rtk_bin="$(_rtk_resolve_rtk)"; then
        export RTK_WRAPPER_IN_PROGRESS=1
        exec "$_rtk_bin" "$rtk_subcommand" "$@"
    else
        # Fallback to native command if RTK not installed
        echo "⚠️ RTK not found, using native $native_cmd. Install RTK for $description." >&2
        exec "$real_bin" "$@"
    fi
}