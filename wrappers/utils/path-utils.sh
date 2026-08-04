#!/usr/bin/env sh
# Shared PATH utilities for wrapper scripts.
#
# This file is inlined into wrapper packages by the Nix shared libraries
# (nix/lib/rtk-wrap-lib.nix, nix/lib/devbox-auto-lib.nix,
# nix/lib/devbox-rtk-lib.nix). It MUST be inlined before any utility that
# calls _wrapper_path_excluding_self (rtk-wrapper.sh, devbox-manager.sh).

# Print PATH with this script's own directory removed (all occurrences).
# Used to avoid infinite recursion when a wrapper's own bin dir is in PATH:
# command -v <tool> would find the wrapper itself, so we exclude it.
# NOTE: naive single-pass bash parameter expansion; if wrapper dir appears 2+
# times in PATH, later copies remain. Upgrade: use IFS loop.
_wrapper_path_excluding_self() {
    local _wrapper_dir
    _wrapper_dir="$(cd "$(dirname "$0")" 2>/dev/null && pwd)"
    if [ -z "$_wrapper_dir" ]; then
        printf '%s' "$PATH"
        return 0
    fi
    local _clean_path="$PATH"
    _clean_path="${_clean_path#"$_wrapper_dir:"}"
    _clean_path="${_clean_path%":$_wrapper_dir"}"
    _clean_path="${_clean_path//":$_wrapper_dir:"/:}"
    printf '%s' "$_clean_path"
}
