#!/usr/bin/env sh
# Source the package detection utility
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/utils/detect-packages.sh" ]; then
    . "$SCRIPT_DIR/utils/detect-packages.sh"
fi

# Detect available alternatives
echo "⚠️ Prefer bun npm pnpm over yarn. Detecting available alternatives..."

# List available alternatives
available_found=false
for tool in bun npm pnpm; do
    if command -v "$tool" >/dev/null 2>&1; then
        if [ "$tool" = "bun" ]; then
            echo "✅ Using $tool (preferred)"
            exec "$tool" "$@"
        else
            echo "ℹ️  $tool is also available"
            available_found=true
        fi
    fi
done

if [ "$available_found" = true ]; then
    echo "💡 Tip: Multiple alternatives detected. Consider standardizing on bun for best compatibility."
fi

# Fallback to preferred tool
echo "🔄 Running bun..."
exec "bun" "$@"
