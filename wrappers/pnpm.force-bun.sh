#!/usr/bin/env sh
echo "✅ Using bun instead of pnpm (forced by policy)..."
exec bun "$@"
