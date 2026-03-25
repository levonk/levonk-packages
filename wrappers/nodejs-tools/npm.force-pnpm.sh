#!/usr/bin/env sh
echo "✅ Using pnpm instead of npm (forced by policy)..."
exec pnpm "$@"
