#!/bin/bash
set -euo pipefail

# Alpine APK Package Generator for Command Governance
# Usage: ./generate-apk.sh <package-name> <behavior-type>

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

APKBUILD_DIR="$SCRIPT_DIR/$PACKAGE_NAME"
mkdir -p "$APKBUILD_DIR"

# Create APKBUILD file
cat > "$APKBUILD_DIR/APKBUILD" << EOF
# Contributor: Command Governance System
# Maintainer: Command Governance System
pkgname=command-$PACKAGE_NAME
pkgver=1.0.0
pkgrel=1
pkgdesc="Command governance: $PACKAGE_NAME - $BEHAVIOR_TYPE behavior"
url="https://github.com/levonk/levonk-packages"
arch="all"
license="MIT"
depends=""
provides="$TARGET_BINARY"
replaces="$TARGET_BINARY"
conflicts="$TARGET_BINARY"

package() {
    mkdir -p "\$pkgdir/usr/bin"
    
    # Install wrapper script
    install -m755 "$PROJECT_ROOT/wrappers/$WRAPPER_SCRIPT" "\$pkgdir/usr/bin/$TARGET_BINARY"
    
    # For eject packages, add pre-install script to remove original
    if [ "$BEHAVIOR_TYPE" = "eject" ]; then
        mkdir -p "\$pkgdir/usr/lib/apk"
        cat > "\$pkgdir/usr/lib/apk/\$pkgname.pre-install" << 'INNER_EOF'
#!/bin/sh
# Remove original package if possible
apk del $TARGET_BINARY 2>/dev/null || true
INNER_EOF
        chmod +x "\$pkgdir/usr/lib/apk/\$pkgname.pre-install"
    fi
}
EOF

echo "✅ Generated APKBUILD for $PACKAGE_NAME"
echo "📍 Location: $APKBUILD_DIR/APKBUILD"
echo ""
echo "To build the package:"
echo "  cd $APKBUILD_DIR"
echo "  abuild -r"
echo ""
echo "To install the package:"
echo "  apk add --allow-untrusted /path/to/$PACKAGE_NAME-*.apk"
