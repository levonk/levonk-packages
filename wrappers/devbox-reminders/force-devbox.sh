#!/usr/bin/env sh
# Get the tool name from argv[0]
TOOL=$(basename "$0")

echo "✅  Forcing devbox run for $TOOL (policy enforcement)..."
echo "💡  AI agents should use: devbox run $TOOL ..."
if command -v devbox >/dev/null 2>&1; then
    dir="$PWD"
    while [ "$dir" != "/" ]; do
        if [ -f "$dir/devbox.json" ]; then
            exec devbox run "$TOOL" "$@"
        fi
        dir="$(dirname "$dir")"
    done
    echo "❌  No devbox.json found in current directory or parents."
    echo "💡  Create one with 'devbox init' or run from a project directory."
    exit 1
else
    echo "❌  devbox is not installed."
    exit 1
fi
