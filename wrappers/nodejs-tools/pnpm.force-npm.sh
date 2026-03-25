#!/usr/bin/env sh
echo "✅ Using npm instead of pnpm (forced by policy)..."
exec npm "$@"
