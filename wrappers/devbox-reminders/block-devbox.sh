#!/usr/bin/env sh
# Get the tool name from argv[0]
TOOL=$(basename "$0")

echo "❌  Direct $TOOL usage is blocked by policy."
echo "💡  AI agents must use: devbox run $TOOL ..."
echo "📚  See: https://jetify.com/docs/devbox/"
exit 1
