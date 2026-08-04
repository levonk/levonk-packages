#!/usr/bin/env sh
# Devbox Management Utility
# Handles devbox.json management and command execution with recursion prevention

# Check if we're already in a devbox environment
is_in_devbox() {
    # Check for devbox environment variables
    [ -n "${DEVBOX_SHELL:-}" ] || [ -n "${IN_DEVBOX:-}" ] || [ -n "${DEVBOX_ENVIRONMENT:-}" ]
}

# Check if command is already prefixed with devbox run
is_devbox_run_command() {
    case "$1" in
        devbox|devbox.exe)
            # Check if it's "devbox run --" or similar
            shift
            [ "$1" = "run" ] && [ "$2" = "--" ]
            ;;
        *)
            false
            ;;
    esac
}

# Find devbox.json directory
find_devbox_json_dir() {
    local current_dir="$(pwd)"
    while [ "$current_dir" != "/" ]; do
        if [ -f "$current_dir/devbox.json" ]; then
            echo "$current_dir"
            return 0
        fi
        current_dir="$(dirname "$current_dir")"
    done
    return 1
}

# Add package to devbox.json
add_package_to_devbox() {
    local package="$1"
    local devbox_dir="$2"
    local devbox_json="$devbox_dir/devbox.json"
    
    # Check if package already exists
    if grep -q "\"$package\"" "$devbox_json" 2>/dev/null; then
        return 0
    fi
    
    # Use jq if available, otherwise fallback to sed
    if command -v jq >/dev/null 2>&1; then
        jq ".packages += [\"$package\"] | .packages | unique" "$devbox_json" > "${devbox_json}.tmp" && mv "${devbox_json}.tmp" "$devbox_json"
    else
        # Fallback: append to packages array (less reliable but works for simple cases)
        sed -i.bak 's/"packages": \[/&\n    "'"$package"'",/' "$devbox_json" && rm -f "${devbox_json}.bak"
    fi
}

# _wrapper_path_excluding_self is defined in utils/path-utils.sh and MUST be
# inlined before this file. See nix/lib/devbox-auto-lib.nix and
# nix/lib/devbox-rtk-lib.nix.

# Check if package is available in current environment, excluding this
# wrapper's own directory from PATH so we don't find the wrapper itself
# (which would cause infinite recursion when the wrapper re-execs the tool).
is_package_available() {
    local package="$1"
    PATH="$(_wrapper_path_excluding_self)" command -v "$package" >/dev/null 2>&1
}

# Translate npx/bunx args to pnpm dlx-compatible args.
# Populates the global _DLX_TRANSLATED_ARGS array.
#
# Translations (partial — only flags pnpm dlx can't accept or where the
# short form differs):
#   -y / --yes / --no        → dropped (pnpm dlx doesn't prompt; defaults to yes)
#   -p <pkg>                 → --package <pkg>  (pnpm dlx only documents long form)
#   -p=<pkg>                 → --package=<pkg>
#   --package / --package=*  → passthrough
#   everything else          → passthrough
#
# Not translated (incompatible flags will error from pnpm dlx explicitly):
#   --node-options, --no-install, --shell, --shell-mode, etc.
_dlx_translate_npx_args() {
    _DLX_TRANSLATED_ARGS=()
    while [ $# -gt 0 ]; do
        case "$1" in
            -y|--yes|--no)
                shift
                ;;
            -p)
                _DLX_TRANSLATED_ARGS+=(--package)
                shift
                if [ $# -gt 0 ]; then
                    _DLX_TRANSLATED_ARGS+=("$1")
                    shift
                fi
                ;;
            -p=*)
                _DLX_TRANSLATED_ARGS+=("--package=${1#-p=}")
                shift
                ;;
            *)
                _DLX_TRANSLATED_ARGS+=("$1")
                shift
                ;;
        esac
    done
}

# Resolve the devbox binary, preferring an upstream install over the nixpkgs
# fallback baked in at build time.
# 1. Look for devbox on PATH excluding this wrapper's own directory (finds
#    user's upstream install — jetify.com installer, manual build, etc. — never
#    the nixpkgs copy that might share the bundle's store path).
# 2. If not found, fall back to DEVBOX_FALLBACK (absolute store path set at
#    build time by the Nix lib, pointing to nixpkgs devbox).
# 3. If neither, return failure so the caller can warn / fall back to native.
_devbox_resolve_devbox() {
    local _found
    _found="$(PATH="$(_wrapper_path_excluding_self)" command -v devbox 2>/dev/null)" || true
    if [ -n "$_found" ]; then
        printf '%s' "$_found"
        return 0
    fi
    if [ -n "${DEVBOX_FALLBACK:-}" ] && [ -x "${DEVBOX_FALLBACK}" ]; then
        printf '%s' "$DEVBOX_FALLBACK"
        return 0
    fi
    return 1
}

# Main devbox wrapper function
devbox_wrap() {
    local tool="$1"
    shift

    # Check recursion prevention - if already being managed by devbox, run directly
    if [ -n "${DEVBOX_AUTO_IN_PROGRESS:-}" ]; then
        exec "$tool" "$@"
    fi

    # Check if we're already in a devbox environment
    if is_in_devbox; then
        # Already in devbox, just run the command
        exec "$tool" "$@"
    fi

    # Check if tool is already available in current environment
    if is_package_available "$tool"; then
        # Tool available, run directly
        exec "$tool" "$@"
    fi

    # Find devbox.json
    local devbox_dir
    if ! devbox_dir="$(find_devbox_json_dir)"; then
        # No devbox.json found, try to run directly
        echo "⚠️ No devbox.json found, running $tool directly"
        exec "$tool" "$@"
    fi

    # Resolve devbox binary: prefer upstream, fall back to bundled nixpkgs copy
    local devbox_bin
    if ! devbox_bin="$(_devbox_resolve_devbox)"; then
        echo "⚠️ devbox not found and no fallback available. Running $tool directly." >&2
        echo "   Install devbox: https://www.jetify.com/devbox" >&2
        exec "$tool" "$@"
    fi

    # Add package to devbox.json if not already present
    add_package_to_devbox "$tool" "$devbox_dir"

    # Run via devbox with recursion prevention
    export DEVBOX_AUTO_IN_PROGRESS=1
    echo "📦 Adding $tool to devbox environment..."

    # Run via devbox
    if [ -d "$devbox_dir" ]; then
        cd "$devbox_dir" && exec "$devbox_bin" run -- "$tool" "$@"
    else
        # Fallback to direct execution
        exec "$tool" "$@"
    fi
}