#!/bin/bash
set -euo pipefail

# Debian DEB Package Generator for Command Governance
# Usage: ./generate-deb.sh <package-name> <behavior-type>

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

DEBIAN_DIR="$SCRIPT_DIR/$PACKAGE_NAME"
mkdir -p "$DEBIAN_DIR/DEBIAN"

# Create control file
cat > "$DEBIAN_DIR/DEBIAN/control" << EOF
Package: command-$PACKAGE_NAME
Version: 1.0.0
Section: utils
Priority: optional
Architecture: all
Maintainer: Command Governance System <dev@example.com>
Description: Command governance: $PACKAGE_NAME - $BEHAVIOR_TYPE behavior
 This package implements command governance for $TARGET_BINARY
 with $BEHAVIOR_TYPE behavior as defined by the Command
 Preference & Package Governance System.
Depends:
Provides: $TARGET_BINARY
Conflicts: $TARGET_BINARY
Replaces: $TARGET_BINARY
EOF

# For eject packages, add preinst script to remove original
if [ "$BEHAVIOR_TYPE" = "eject" ]; then
    cat > "$DEBIAN_DIR/DEBIAN/preinst" << EOF
#!/bin/bash
set -e
# Remove original package if possible
apt-get remove --purge -y $TARGET_BINARY 2>/dev/null || true
dpkg -r $TARGET_BINARY 2>/dev/null || true
EOF
    chmod +x "$DEBIAN_DIR/DEBIAN/preinst"
fi

# Create directory structure and install files
mkdir -p "$DEBIAN_DIR/usr/bin"
cp "$PROJECT_ROOT/wrappers/$WRAPPER_SCRIPT" "$DEBIAN_DIR/usr/bin/$TARGET_BINARY"
chmod +x "$DEBIAN_DIR/usr/bin/$TARGET_BINARY"

# Create DEB package
cd "$SCRIPT_DIR"
dpkg-deb --build "$PACKAGE_NAME"

echo "✅ Generated DEB package for $PACKAGE_NAME"
echo "📍 Location: $SCRIPT_DIR/$PACKAGE_NAME.deb"
echo ""
echo "To install the package:"
echo "  sudo dpkg -i $SCRIPT_DIR/$PACKAGE_NAME.deb"
echo "  sudo apt-get install -f  # Fix dependencies if needed"
