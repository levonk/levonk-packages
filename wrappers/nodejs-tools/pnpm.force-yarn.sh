#!/usr/bin/env sh
echo "✅ Using yarn instead of pnpm (forced by policy)..."
exec yarn "$@"
