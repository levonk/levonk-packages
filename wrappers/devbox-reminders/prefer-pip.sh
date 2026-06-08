#!/usr/bin/env sh
# Get the tool name from argv[0]
TOOL=$(basename "$0")

# If REAL_TOOL is provided (e.g. by Nix), use it directly
if [ -n "$REAL_TOOL" ]; then
    echo "⚠️  AI Agent Reminder: Use 'devbox run $TOOL ...' instead of '$TOOL ...'"
    echo "💡  The devbox environment ensures correct toolchain configuration."
    echo "🔄  Proceeding with direct $TOOL execution (for backwards compatibility)..."
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

echo "⚠️  AI Agent Reminder: Use 'devbox run $TOOL ...' instead of '$TOOL ...'"
echo "💡  The devbox environment ensures correct toolchain configuration."
if [ -n "$REAL_TOOL" ]; then
    echo "🔄  Proceeding with direct $TOOL execution (for backwards compatibility)..."
    exec "$REAL_TOOL" "$@"
else
    echo "❌  Could not find real $TOOL binary in PATH."
    echo "💡  Try: devbox run $TOOL ..."
    exit 1
fi
