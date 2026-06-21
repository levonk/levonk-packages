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

# Check if package is available in current environment
is_package_available() {
    local package="$1"
    command -v "$package" >/dev/null 2>&1
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
    
    # Add package to devbox.json if not already present
    add_package_to_devbox "$tool" "$devbox_dir"
    
    # Run via devbox with recursion prevention
    export DEVBOX_AUTO_IN_PROGRESS=1
    echo "📦 Adding $tool to devbox environment..."
    
    # Run via devbox
    if [ -d "$devbox_dir" ]; then
        cd "$devbox_dir" && exec devbox run -- "$tool" "$@"
    else
        # Fallback to direct execution
        exec "$tool" "$@"
    fi
}