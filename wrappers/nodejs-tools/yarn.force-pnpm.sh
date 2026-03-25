#!/usr/bin/env sh
echo "✅ Using pnpm instead of yarn (forced by policy)..."
exec pnpm "$@"
