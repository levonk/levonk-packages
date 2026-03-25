#!/usr/bin/env sh
echo "✅ Using npm instead of bun (forced by policy)..."
exec npm "$@"
