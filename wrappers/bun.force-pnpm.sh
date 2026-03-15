#!/usr/bin/env sh
echo "✅ Using pnpm instead of bun (forced by policy)..."
exec pnpm "$@"
