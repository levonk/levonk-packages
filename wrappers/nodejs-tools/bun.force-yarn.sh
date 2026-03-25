#!/usr/bin/env sh
echo "✅ Using yarn instead of bun (forced by policy)..."
exec yarn "$@"
