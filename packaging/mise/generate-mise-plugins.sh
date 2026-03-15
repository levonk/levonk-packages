#!/bin/bash
set -euo pipefail

# mise Plugin Generator for Command Governance
# Usage: ./generate-mise-plugins.sh <package-name> <behavior-type>

PACKAGE_NAME="$1"
BEHAVIOR_TYPE="$2"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

if [ -z "$PACKAGE_NAME" ] || [ -z "$BEHAVIOR_TYPE" ]; then
    echo "Usage: $0 <package-name> <behavior-type>"
    echo "Example: $0 prefer-pnpm prefer"
    echo "Behavior types: prefer, eject, force, block"
    exit 1
fi

# Validate behavior type
case "$BEHAVIOR_TYPE" in
    prefer|eject|force|block) ;;
    *)
        echo "Error: Invalid behavior type '$BEHAVIOR_TYPE'"
        echo "Valid types: prefer, eject, force, block"
        exit 1
        ;;
esac

# Determine the target binary and wrapper script
case "$PACKAGE_NAME" in
    prefer-pnpm|force-pnpm|block-npm|eject-npm)
        TARGET_BINARY="npm"
        WRAPPER_SCRIPT="npm.${PACKAGE_NAME}.sh"
        ;;
    prefer-uv|block-pip|eject-pip)
        TARGET_BINARY="pip"
        WRAPPER_SCRIPT="pip.${PACKAGE_NAME}.sh"
        ;;
    prefer-devbox)
        TARGET_BINARY="curl"
        WRAPPER_SCRIPT="curl.${PACKAGE_NAME}.sh"
        ;;
    prefer-corepack)
        TARGET_BINARY="node"
        WRAPPER_SCRIPT="node.${PACKAGE_NAME}.sh"
        ;;
    *)
        echo "Error: Unknown package '$PACKAGE_NAME'"
        exit 1
        ;;
esac

PLUGIN_DIR="$SCRIPT_DIR/$PACKAGE_NAME"
mkdir -p "$PLUGIN_DIR/bin"

# Create plugin manifest
cat > "$PLUGIN_DIR/plugin.toml" << EOF
[plugin]
name = "command-$PACKAGE_NAME"
description = "Command governance: $PACKAGE_NAME - $BEHAVIOR_TYPE behavior"
version = "1.0.0"
author = "Command Governance System"
source_url = "https://github.com/levonk/levonk-packages"

[commands."$TARGET_BINARY"]
description = "Governed $TARGET_BINARY with $BEHAVIOR_TYPE behavior"
EOF

# Create bin directory and install script
cat > "$PLUGIN_DIR/bin/install.sh" << EOF
#!/bin/bash
set -euo pipefail

# mise plugin install script for $PACKAGE_NAME
SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$PROJECT_ROOT"

# Copy wrapper script to mise installation directory
mkdir -p "\$MISE_DATA_DIR/bin"
cp "$PROJECT_ROOT/wrappers/$WRAPPER_SCRIPT" "\$MISE_DATA_DIR/bin/$TARGET_BINARY"
chmod +x "\$MISE_DATA_DIR/bin/$TARGET_BINARY"

echo "✅ Installed $PACKAGE_NAME governance for $TARGET_BINARY"
EOF

chmod +x "$PLUGIN_DIR/bin/install.sh"

echo "✅ Generated mise plugin for $PACKAGE_NAME"
echo "📍 Location: $PLUGIN_DIR"
echo ""
echo "To use this plugin:"
echo "  mise plugin install $PACKAGE_NAME file://$PLUGIN_DIR"
echo "  mise use $PACKAGE_NAME"
echo ""
echo "Or install directly from git:"
echo "  mise plugin install $PACKAGE_NAME https://github.com/levonk/levonk-packages.git"
echo "  mise use $PACKAGE_NAME"
