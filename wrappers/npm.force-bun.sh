#!/usr/bin/env sh
echo "✅ Using bun instead of npm (forced by policy)..."
exec bun "$@"
