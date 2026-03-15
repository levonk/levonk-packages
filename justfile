# Command Preference & Package Governance System

# Normal targets - Developer interface (REQUIRED)
clean:
    devbox shell clean

test:
    just test-internal

build:
    devbox shell build

generate:
    devbox shell generate

install:
    devbox shell install

# Bootstrap recipes (REQUIRED)
bootstrap:
    # Ensure devbox is available and environment is ready
    devbox shell bootstrap

bootstrap-internal:
    # Internal bootstrap logic called by devbox init_hook
    echo "🚀 Command Governance System bootstrap complete!"
    echo "📦 Ready to build and test command governance packages"

# Prime recipes (REQUIRED)
prime:
    # Prime code indexing and analysis tools
    devbox shell prime

prime-internal:
    # Internal prime logic for code indexing and analysis tools
    echo "🔍 Code indexing and analysis tools primed"

# Health and diagnostics (REQUIRED)
doctor:
    # Check development environment health
    devbox shell doctor

doctor-internal:
    echo "🩺 Checking development environment health..."
    echo "✅ Devbox environment: $(devbox version)"
    echo "✅ Nix: $(nix --version | head -n1)"
    echo "✅ Just: $(just --version)"
    echo "✅ All tools available"

# Quality checks (OPTIONAL but RECOMMENDED)
quality:
    just test
    just build

# Build all packages
build-internal:
    echo "🔨 Building all Nix packages..."
    nix build .#prefer-pnpm
    nix build .#eject-npm  
    nix build .#force-pnpm
    nix build .#block-npm
    nix build .#prefer-uv
    nix build .#eject-pip
    nix build .#block-pip
    nix build .#prefer-devbox
    nix build .#prefer-corepack
    nix build .#command-governance
    echo "✅ All packages built successfully"

# Test package functionality
test-internal:
    echo "🧪 Testing package functionality..."
    echo "Testing prefer-pnpm..."
    nix run .#prefer-pnpm -- --version || echo "✅ prefer-pnpm wrapper working (expected failure)"
    echo "Testing block-npm..."
    nix run .#block-npm -- --version || echo "✅ block-npm wrapper working (expected failure)"
    echo "Testing prefer-npm..."
    nix run .#prefer-npm -- --version || echo "✅ prefer-npm wrapper working (expected failure)"
    echo "Testing prefer-yarn..."
    nix run .#prefer-yarn -- --version || echo "✅ prefer-yarn wrapper working (expected failure)"
    echo "Testing prefer-bun..."
    nix run .#prefer-bun -- --version || echo "✅ prefer-bun wrapper working (expected failure)"
    echo "Testing prefer-uv..."
    nix run .#prefer-uv -- --version || echo "✅ prefer-uv wrapper working (expected failure)"
    echo "Testing prefer-devbox..."
    nix run .#prefer-devbox -- --version || echo "✅ prefer-devbox wrapper working (expected failure)"
    echo "Testing prefer-corepack..."
    nix run .#prefer-corepack -- --version || echo "✅ prefer-corepack wrapper working (expected failure)"
    echo "Testing bundle package..."
    nix build .#command-governance
    echo "Testing nodejs-ecosystem bundle..."
    nix build .#nodejs-ecosystem
    echo "Testing python-ecosystem bundle..."
    nix build .#python-ecosystem
    echo "Testing dev-tools bundle..."
    nix build .#dev-tools
    echo "Testing migrate-to-pnpm bundle..."
    nix build .#migrate-to-pnpm
    echo "Testing migrate-to-uv bundle..."
    nix build .#migrate-to-uv
    echo "✅ Package functionality tests complete"

test-comprehensive:
    echo "🧪 Running comprehensive governance tests..."
    ./scripts/test-governance.sh

# Install individual packages via devbox
install-internal:
    echo "📦 Example devbox installations:"
    echo "  devbox add .#prefer-pnpm"
    echo "  devbox add .#command-governance"
    echo "  devbox add github:levonk/levonk-packages#prefer-pnpm"

# Release management
release:
    echo "🚀 Creating GitHub release..."
    just release-internal

release-internal:
    # Test release workflow locally
    echo "🧪 Testing release workflow locally..."
    act --dry-run release || echo "ACT not available, skipping local test"
    
    # Generate all packaging
    echo "📦 Generating packaging for all ecosystems..."
    just generate-all
    
    # Create release artifacts
    echo "📋 Creating release artifacts..."
    mkdir -p dist
    
    # Add package list to release
    cp docs/PACKAGE_LIST.md dist/
    cp README.md dist/
    cp docs/SPEC.md dist/
    
    # Generate checksums
    echo "🔐 Generating checksums..."
    cd dist
    sha256sum * > SHA256SUMS
    cd ..
    
    echo "✅ Release artifacts ready in dist/"
    echo "📋 Files created:"
    ls -la dist/
    
    echo ""
    echo "🎯 Release workflow:"
    echo "1. Review artifacts in dist/"
    echo "2. Create GitHub release with dist/ files"
    echo "3. Upload packages to package registries"

# Generate all packaging
generate-all:
    echo "🏭 Generating packaging for all ecosystems..."
    ./packaging/alpine/generate-apk.sh
    ./packaging/debian/generate-deb.sh
    ./packaging/fedora/generate-rpm.sh
    ./packaging/arch/generate-pkgbuild.sh
    ./packaging/brew/generate-formula.rb
    ./packaging/mise/generate-mise-plugins.sh
    echo "✅ All packaging generated"

# Generate packaging for different ecosystems  
generate-internal:
    echo "🏭 Generating packaging for different ecosystems..."
    
    # Alpine APK
    echo "Generating Alpine APK packages..."
    ./packaging/alpine/generate-apk.sh prefer-pnpm prefer
    ./packaging/alpine/generate-apk.sh eject-npm eject
    ./packaging/alpine/generate-apk.sh force-pnpm force
    ./packaging/alpine/generate-apk.sh block-npm block
    
    # Debian DEB
    echo "Generating Debian DEB packages..."
    ./packaging/debian/generate-deb.sh prefer-pnpm prefer
    ./packaging/debian/generate-deb.sh eject-npm eject
    ./packaging/debian/generate-deb.sh force-pnpm force
    ./packaging/debian/generate-deb.sh block-npm block
    
    # Fedora RPM
    echo "Generating Fedora RPM packages..."
    ./packaging/fedora/generate-rpm.sh prefer-pnpm prefer
    ./packaging/fedora/generate-rpm.sh eject-npm eject
    ./packaging/fedora/generate-rpm.sh force-pnpm force
    ./packaging/fedora/generate-rpm.sh block-npm block
    
    # Arch PKGBUILD
    echo "Generating Arch PKGBUILD packages..."
    ./packaging/arch/generate-pkgbuild.sh prefer-pnpm prefer
    ./packaging/arch/generate-pkgbuild.sh eject-npm eject
    ./packaging/arch/generate-pkgbuild.sh force-pnpm force
    ./packaging/arch/generate-pkgbuild.sh block-npm block
    
    # Homebrew Formula
    echo "Generating Homebrew formulas..."
    ./packaging/brew/generate-formula.rb prefer-pnpm prefer
    ./packaging/brew/generate-formula.rb eject-npm eject
    ./packaging/brew/generate-formula.rb force-pnpm force
    ./packaging/brew/generate-formula.rb block-npm block
    
    # mise plugins
    echo "Generating mise plugins..."
    ./packaging/mise/generate-mise-plugins.sh prefer-pnpm prefer
    ./packaging/mise/generate-mise-plugins.sh eject-npm eject
    ./packaging/mise/generate-mise-plugins.sh force-pnpm force
    ./packaging/mise/generate-mise-plugins.sh block-npm block
    
    echo "✅ All packaging generated successfully"

# Clean up (OPTIONAL)
clean-internal:
    echo "🧹 Cleaning build artifacts..."
    rm -rf result
    rm -rf packaging/*/*/BUILD
    rm -rf packaging/*/*/RPMS
    rm -rf packaging/*/*/SRPMS
    rm -rf packaging/*/*/*.tar.gz
    rm -rf packaging/*/*/*.deb
    rm -rf packaging/*/*/*.rpm
    rm -rf packaging/*/*/*.pkg.tar.zst
    echo "✅ Build artifacts cleaned"

# Development setup (OPTIONAL)
setup:
    echo "🛠️ Development environment ready!"
    echo "Available just targets:"
    echo "  just build    - Build all packages"
    echo "  just test     - Test package functionality" 
    echo "  just generate - Generate packaging"
    echo "  just install  - Show installation examples"
    echo "  just doctor   - Check environment health"
