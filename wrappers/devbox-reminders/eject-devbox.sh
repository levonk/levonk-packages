#!/usr/bin/env sh
# Get the tool name from argv[0]
TOOL=$(basename "$0")

# If REAL_TOOL is provided (e.g. by Nix), use it directly
# This prevents recursive loops when running in devbox environment
if [ -n "$REAL_TOOL" ]; then
    echo "🚀  Ejecting direct $TOOL usage in favor of devbox..."
    echo "💡  AI agents should use: devbox run $TOOL ..."
    echo "🔄  Running $TOOL directly..."
    exec "$REAL_TOOL" "$@"
fi

echo "🚀  Ejecting direct $TOOL usage in favor of devbox..."
echo "💡  AI agents should use: devbox run $TOOL ..."
if command -v devbox >/dev/null 2>&1; then
    dir="$PWD"
    while [ "$dir" != "/" ]; do
        if [ -f "$dir/devbox.json" ]; then
            exec devbox run "$TOOL" "$@"
        fi
        dir="$(dirname "$dir")"
    done
    echo "⚠️  devbox.json not found. Falling back to direct $TOOL."
fi

# If REAL_TOOL is provided (e.g. by Nix), use it directly
if [ -n "$REAL_TOOL" ]; then
    echo "🔄  Running $TOOL directly..."
    exec "$REAL_TOOL" "$@"
fi

# Find the real binary by skipping ourselves in PATH
_find_real_tool() {
    _tool="$1"
    _wrapper=$(command -v "$_tool")
    _found=false
    _oldifs="$IFS"
    IFS=':'
    for _dir in $PATH; do
        _candidate="$_dir/$_tool"
        if [ "$_found" = true ] && [ -x "$_candidate" ]; then
            echo "$_candidate"
            break
        fi
        if [ "$_candidate" = "$_wrapper" ]; then
            _found=true
        fi
    done
    IFS="$_oldifs"
}

REAL_TOOL=$(_find_real_tool "$TOOL")

if [ -n "$REAL_TOOL" ]; then
    echo "🔄  Running $TOOL directly..."
    exec "$REAL_TOOL" "$@"
else
    echo "❌  Could not find real $TOOL binary in PATH."
    exit 1
fi
