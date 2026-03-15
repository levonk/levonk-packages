#!/bin/bash
set -euo pipefail

# Arch PKGBUILD Generator for Command Governance
# Usage: ./generate-pkgbuild.sh <package-name> <behavior-type>

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

PKGBUILD_DIR="$SCRIPT_DIR/$PACKAGE_NAME"
mkdir -p "$PKGBUILD_DIR"

# Create PKGBUILD file
cat > "$PKGBUILD_DIR/PKGBUILD" << EOF
# Maintainer: Command Governance System <dev@example.com>
pkgname=command-$PACKAGE_NAME
pkgver=1.0.0
pkgrel=1
pkgdesc="Command governance: $PACKAGE_NAME - $BEHAVIOR_TYPE behavior"
arch=('any')
url="https://github.com/levonk/levonk-packages"
license=('MIT')
provides=('$TARGET_BINARY')
conflicts=('$TARGET_BINARY')
replaces=('$TARGET_BINARY')
source=("\$pkgname-\$pkgver.tar.gz")

package() {
    mkdir -p "\$pkgdir/usr/bin"
    install -m755 "\$srcdir/wrappers/$WRAPPER_SCRIPT" "\$pkgdir/usr/bin/$TARGET_BINARY"
}

# For eject packages, add removal logic
EOF

if [ "$BEHAVIOR_TYPE" = "eject" ]; then
    cat >> "$PKGBUILD_DIR/PKGBUILD" << 'INNER_EOF'

prepare() {
    # Remove original package if possible
    sudo pacman -R --noconfirm $TARGET_BINARY 2>/dev/null || true
}
INNER_EOF
fi

echo "# Generated PKGBUILD for $PACKAGE_NAME" >> "$PKGBUILD_DIR/PKGBUILD"

# Create install script (if needed for eject)
if [ "$BEHAVIOR_TYPE" = "eject" ]; then
    cat > "$PKGBUILD_DIR/$PACKAGE_NAME.install" << EOF
pre_install() {
    # Remove original package if possible
    pacman -R --noconfirm $TARGET_BINARY 2>/dev/null || true
}
EOF
    echo "install=$PACKAGE_NAME.install" >> "$PKGBUILD_DIR/PKGBUILD"
fi

echo "✅ Generated PKGBUILD for $PACKAGE_NAME"
echo "📍 Location: $PKGBUILD_DIR/PKGBUILD"
echo ""
echo "To build the package:"
echo "  cd $PKGBUILD_DIR"
echo "  makepkg"
echo ""
echo "To install the package:"
echo "  sudo pacman -U $PACKAGE_NAME-1.0.0-1-any.pkg.tar.zst"
