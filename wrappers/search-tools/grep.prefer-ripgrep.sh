#!/usr/bin/env sh
# Source the package detection utility
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/detect-packages.sh" ]; then
    . "$SCRIPT_DIR/utils/detect-packages.sh"
fi

# Detect available alternatives
echo "⚠️ Prefer ripgrep over grep. Detecting available alternatives..."

# List available alternatives
available_found=false
for tool in rg; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "✅ Using $tool (preferred)"
        exec "$tool" "$@"
    fi
done

# Fallback to ripgrep
echo "🔄 Running ripgrep..."
exec rg "$@"
