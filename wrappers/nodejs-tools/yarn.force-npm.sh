#!/usr/bin/env sh
echo "✅ Using npm instead of yarn (forced by policy)..."
exec npm "$@"
