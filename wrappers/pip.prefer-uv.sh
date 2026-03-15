#!/usr/bin/env sh
echo "⚠️ Prefer uv over pip. Running uv instead..."
exec uv "$@"
