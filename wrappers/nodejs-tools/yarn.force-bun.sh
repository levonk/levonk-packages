#!/usr/bin/env sh
echo "✅ Using bun instead of yarn (forced by policy)..."
exec bun "$@"
