#!/usr/bin/env sh
echo "⚠️ Prefer devbox over curl for environment setup. Use devbox commands instead..."
echo "If you need curl for HTTP requests, it remains available for non-environment tasks."
exec curl "$@"
