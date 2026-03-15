#!/bin/bash
set -euo pipefail

# Update all wrapper scripts with dynamic package detection

echo "🔄 Updating wrapper scripts with dynamic package detection..."

# Function to update a wrapper script
update_wrapper() {
    local wrapper_file="$1"
    local target_binary="$2"
    local preferred_tools="$3"
    local behavior="$4"
    
    echo "Updating $wrapper_file..."
    
    case "$behavior" in
        prefer)
            cat > "$wrapper_file" << EOF
#!/usr/bin/env sh
# Source the package detection utility
SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
if [ -f "\$SCRIPT_DIR/utils/detect-packages.sh" ]; then
    . "\$SCRIPT_DIR/utils/detect-packages.sh"
fi

# Detect available alternatives
echo "⚠️ Prefer $preferred_tools over $target_binary. Detecting available alternatives..."

# List available alternatives
preferred_tools="$preferred_tools"
available_found=false
for tool in \$preferred_tools; do
    if command -v "\$tool" >/dev/null 2>&1; then
        if [ "\$tool" = "$(echo \$preferred_tools | awk '{print \$1}')" ]; then
            echo "✅ Using \$tool (preferred)"
            exec "\$(echo \$preferred_tools | awk '{print \$1}')" "\$@"
        else
            echo "ℹ️  \$tool is also available"
            available_found=true
        fi
    fi
done

if [ "\$available_found" = true ]; then
    echo "💡 Tip: Multiple alternatives detected. Consider standardizing on \$(echo \$preferred_tools | awk '{print \$1}') for best compatibility."
fi

# Fallback to preferred tool
echo "🔄 Running \$(echo \$preferred_tools | awk '{print \$1}')..."
exec \$(echo \$preferred_tools | awk '{print \$1}') "\$@"
EOF
            ;;
        force)
            cat > "$wrapper_file" << EOF
#!/usr/bin/env sh
echo "✅ Using \$(echo $preferred_tools | awk '{print \$1}') instead of $target_binary (forced by policy)..."
exec \$(echo $preferred_tools | awk '{print \$1}') "\$@"
EOF
            ;;
        block)
            cat > "$wrapper_file" << EOF
#!/usr/bin/env sh
echo "❌ $target_binary is blocked by policy. Use $preferred_tools instead."
exit 1
EOF
            ;;
        eject)
            cat > "$wrapper_file" << EOF
#!/usr/bin/env sh
echo "❌ $target_binary has been ejected by policy."
echo "$target_binary has been removed and future installs are blocked."
echo "Use $preferred_tools instead."
exit 1
EOF
            ;;
    esac
    
    chmod +x "$wrapper_file"
}

# Update npm wrappers
echo "Updating npm wrappers..."
update_wrapper "wrappers/npm.prefer-pnpm.sh" "npm" "pnpm yarn bun" "prefer"
update_wrapper "wrappers/npm.prefer-yarn.sh" "npm" "yarn pnpm bun" "prefer"
update_wrapper "wrappers/npm.prefer-bun.sh" "npm" "bun pnpm yarn" "prefer"

# Update pnpm wrappers
echo "Updating pnpm wrappers..."
update_wrapper "wrappers/pnpm.prefer-npm.sh" "pnpm" "npm yarn bun" "prefer"
update_wrapper "wrappers/pnpm.prefer-yarn.sh" "pnpm" "yarn npm bun" "prefer"
update_wrapper "wrappers/pnpm.prefer-bun.sh" "pnpm" "bun npm yarn" "prefer"

# Update yarn wrappers
echo "Updating yarn wrappers..."
update_wrapper "wrappers/yarn.prefer-npm.sh" "yarn" "npm pnpm bun" "prefer"
update_wrapper "wrappers/yarn.prefer-pnpm.sh" "yarn" "pnpm npm bun" "prefer"
update_wrapper "wrappers/yarn.prefer-bun.sh" "yarn" "bun npm pnpm" "prefer"

# Update bun wrappers
echo "Updating bun wrappers..."
update_wrapper "wrappers/bun.prefer-npm.sh" "bun" "npm pnpm yarn" "prefer"
update_wrapper "wrappers/bun.prefer-pnpm.sh" "bun" "pnpm npm yarn" "prefer"
update_wrapper "wrappers/bun.prefer-yarn.sh" "bun" "yarn npm pnpm" "prefer"

# Update pip wrapper
echo "Updating pip wrapper..."
update_wrapper "wrappers/pip.prefer-uv.sh" "pip" "uv pip-tools" "prefer"

echo "✅ All wrapper scripts updated with dynamic package detection!"
