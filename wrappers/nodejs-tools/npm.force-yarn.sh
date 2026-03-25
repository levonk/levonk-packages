#!/usr/bin/env sh
echo "✅ Using yarn instead of npm (forced by policy)..."
exec yarn "$@"
