#!/bin/bash
set -euo pipefail

# Fedora RPM Package Generator for Command Governance
# Usage: ./generate-rpm.sh <package-name> <behavior-type>

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

RPM_DIR="$SCRIPT_DIR/$PACKAGE_NAME"
mkdir -p "$RPM_DIR/{BUILD,RPMS,SOURCES,SPECS,SRPMS}"

# Create spec file
cat > "$RPM_DIR/SPECS/$PACKAGE_NAME.spec" << EOF
Name:           command-$PACKAGE_NAME
Version:        1.0.0
Release:        1%{?dist}
Summary:        Command governance: $PACKAGE_NAME - $BEHAVIOR_TYPE behavior

License:        MIT
URL:            https://github.com/levonk/levonk-packages
Source0:        %{name}-%{version}.tar.gz

Provides:       $TARGET_BINARY
Conflicts:      $TARGET_BINARY

%description
This package implements command governance for $TARGET_BINARY
with $BEHAVIOR_TYPE behavior as defined by the Command
Preference & Package Governance System.

%prep
%autosetup

%install
mkdir -p %{buildroot}/usr/bin
install -m755 wrappers/$WRAPPER_SCRIPT %{buildroot}/usr/bin/$TARGET_BINARY

%files
/usr/bin/$TARGET_BINARY

%changelog
* $(date +'%a %b %d %Y') Command Governance System <dev@example.com> - 1.0.0-1
- Initial package for $PACKAGE_NAME with $BEHAVIOR_TYPE behavior
EOF

# For eject packages, add %pre script to remove original
if [ "$BEHAVIOR_TYPE" = "eject" ]; then
    cat >> "$RPM_DIR/SPECS/$PACKAGE_NAME.spec" << EOF

%pre
# Remove original package if possible
dnf remove -y $TARGET_BINARY 2>/dev/null || true
rpm -e $TARGET_BINARY 2>/dev/null || true
EOF
fi

# Create source tarball
cd "$SCRIPT_DIR"
mkdir -p "$PACKAGE_NAME-$VERSION"
cp -r "$PROJECT_ROOT/wrappers" "$PACKAGE_NAME-$VERSION/"
tar -czf "$PACKAGE_NAME-$VERSION.tar.gz" "$PACKAGE_NAME-$VERSION/"
rm -rf "$PACKAGE_NAME-$VERSION"

# Build RPM
cd "$RPM_DIR"
rpmbuild --define "_topdir $RPM_DIR" -ba SPECS/$PACKAGE_NAME.spec

echo "✅ Generated RPM package for $PACKAGE_NAME"
echo "📍 Location: $RPM_DIR/RPMS/noarch/command-$PACKAGE_NAME-1.0.0-1.*.rpm"
echo ""
echo "To install the package:"
echo "  sudo dnf install $RPM_DIR/RPMS/noarch/command-$PACKAGE_NAME-1.0.0-1.*.rpm"
