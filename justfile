# Command Preference & Package Governance System

_log := '
_jv_has() {
  local cat="$1"
  local v="${JUST_LOG:-0}"
  case "$v" in
    1|all) return 0 ;;
    0|"") return 1 ;;
  esac
  v="${v//startend/start,end}"
  echo ",$v," | grep -q ",$cat,"
}
log_info()   { _jv_has info   && echo "$*" || true; }
log_start()  { _jv_has start  && echo "▶ $*" || true; }
log_end()    { _jv_has end    && echo "✔ $*" || true; }
log_status() { _jv_has status && echo "$*" || true; }
log_warn()   { echo "⚠️  $*" >&2; }
log_error()  { echo "❌ $*" >&2; }
log_startend() {
  local msg="$1"; shift
  local rc
  _jv_has start && echo "▶ $msg" || true
  rc=0; "$@" || rc=$?
  _jv_has end && echo "✔ $msg complete" || true
  return $rc
}
'

# Devbox auto-detection: run impl target directly if in devbox,
# re-exec via devbox run if not, or fail with doctor diagnostic.
_devbox target *args:
    #!/usr/bin/env bash
    {{_log}}
    if [ "${DEVBOX_SHELL_ENABLED:-0}" = "1" ]; then
        exec just "{{target}}" {{args}}
    elif command -v devbox >/dev/null 2>&1; then
        exec devbox run -- just "{{target}}" {{args}}
    else
        log_error "devbox not found in PATH."
        log_warn "Running doctor to diagnose environment issues..."
        just doctor 2>/dev/null || true
        exit 1
    fi

# Normal targets - Developer interface (REQUIRED)
clean:
    @just _devbox clean_impl

test:
    @just _devbox test_impl

build:
    @just _devbox build_impl

generate:
    @just _devbox generate_impl

install:
    @just _devbox install_impl

# Bootstrap recipes (REQUIRED)
bootstrap:
    # Ensure devbox is available and environment is ready
    @just _devbox bootstrap_impl

# Prime recipes (REQUIRED)
prime:
    # Prime code indexing and analysis tools
    @just _devbox prime_impl

# Health and diagnostics (REQUIRED)
doctor:
    # Check development environment health
    @just _devbox doctor_impl

# Quality checks (OPTIONAL but RECOMMENDED)
quality:
    @just test
    @just build

# Test ripgrep governance packages specifically
test-ripgrep:
    @just _devbox test_ripgrep_impl

# Test Node.js governance packages specifically
test-nodejs:
    @just _devbox test_nodejs_impl

# Test specific package
test-package package='':
    @just _devbox test_package_impl {{package}}

test-comprehensive:
    @just _devbox test_comprehensive_impl

# Bats tests for wrapper utilities (recursion fix, dlx routing, etc.)
test-wrappers:
    @just _devbox test_wrappers_impl

# Release management
release:
    @just _devbox release_impl

# Generate all packaging
generate-all:
    @just _devbox generate_all_impl

# Development setup (OPTIONAL)
setup:
    #!/usr/bin/env bash
    {{_log}}
    log_end "Development environment ready!"
    echo "Available just targets:"
    echo "  just build    - Build all packages"
    echo "  just test     - Test package functionality"
    echo "  just generate - Generate packaging"
    echo "  just install  - Show installation examples"
    echo "  just doctor   - Check environment health"

# =============================================================================
# Implementation targets (private)
# =============================================================================

[private]
bootstrap_impl:
    #!/usr/bin/env bash
    set -euo pipefail
    {{_log}}
    log_end "Command Governance System bootstrap complete"
    log_info "Ready to build and test command governance packages"

[private]
prime_impl:
    #!/usr/bin/env bash
    set -euo pipefail
    {{_log}}
    log_end "Code indexing and analysis tools primed"

[private]
doctor_impl:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "🩺 Checking development environment health..."
    echo "✅ Devbox environment: $(devbox version)"
    echo "✅ Nix: $(nix --version | head -n1)"
    echo "✅ Just: $(just --version)"
    echo "✅ All tools available"

[private]
build_impl:
    #!/usr/bin/env bash
    set -euo pipefail
    {{_log}}
    log_start "Building all Nix packages"
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
    log_end "All packages built successfully"

[private]
test_impl:
    #!/usr/bin/env bash
    set -euo pipefail
    {{_log}}
    log_start "Testing package functionality with unified framework"
    ./scripts/test-governance-unified.sh all
    log_end "Package functionality tests complete"

[private]
test_ripgrep_impl:
    #!/usr/bin/env bash
    set -euo pipefail
    {{_log}}
    log_start "Testing ripgrep governance packages"
    ./scripts/test-governance-unified.sh search
    log_end "Ripgrep package functionality tests complete"

[private]
test_nodejs_impl:
    #!/usr/bin/env bash
    set -euo pipefail
    {{_log}}
    log_start "Testing Node.js governance packages"
    ./scripts/test-governance-unified.sh nodejs
    log_end "Node.js package functionality tests complete"

[private]
test_package_impl package='':
    #!/usr/bin/env bash
    set -euo pipefail
    {{_log}}
    if [ -z "{{package}}" ]; then
        echo "Usage: just test-package <package-name>"
        echo "Example: just test-package prefer-grep"
        exit 1
    fi
    log_start "Testing specific package: {{package}}"
    ./scripts/test-governance-unified.sh "{{package}}"

[private]
test_comprehensive_impl:
    #!/usr/bin/env bash
    set -euo pipefail
    {{_log}}
    log_start "Running comprehensive governance tests"
    ./scripts/test-governance.sh

[private]
test_wrappers_impl:
    #!/usr/bin/env bash
    set -euo pipefail
    {{_log}}
    log_start "Running bats wrapper tests"
    bats tests/wrappers-recursion.bats
    log_end "Wrapper bats tests complete"

[private]
install_impl:
    #!/usr/bin/env bash
    set -euo pipefail
    {{_log}}
    log_info "Example devbox installations:"
    echo "  devbox add .#prefer-pnpm"
    echo "  devbox add .#command-governance"
    echo "  devbox add github:levonk/levonk-packages#prefer-pnpm"

[private]
release_impl:
    #!/usr/bin/env bash
    set -euo pipefail
    {{_log}}
    log_start "Testing release workflow locally"
    act --dry-run release || log_warn "ACT not available, skipping local test"

    # Generate all packaging
    log_info "Generating packaging for all ecosystems..."
    just generate-all

    # Create release artifacts
    log_info "Creating release artifacts..."
    mkdir -p dist

    # Add package list to release
    cp docs/PACKAGE_LIST.md dist/
    cp README.md dist/
    cp docs/SPEC.md dist/

    # Generate checksums
    log_info "Generating checksums..."
    cd dist
    sha256sum * > SHA256SUMS
    cd ..

    log_end "Release artifacts ready in dist/"
    echo "📋 Files created:"
    ls -la dist/

    echo ""
    echo "🎯 Release workflow:"
    echo "1. Review artifacts in dist/"
    echo "2. Create GitHub release with dist/ files"
    echo "3. Upload packages to package registries"

[private]
generate_all_impl:
    #!/usr/bin/env bash
    set -euo pipefail
    {{_log}}
    log_start "Generating packaging for all ecosystems"
    ./packaging/alpine/generate-apk.sh
    ./packaging/debian/generate-deb.sh
    ./packaging/fedora/generate-rpm.sh
    ./packaging/arch/generate-pkgbuild.sh
    ./packaging/brew/generate-formula.rb
    ./packaging/mise/generate-mise-plugins.sh
    log_end "All packaging generated"

[private]
generate_impl:
    #!/usr/bin/env bash
    set -euo pipefail
    {{_log}}
    log_start "Generating packaging for different ecosystems"

    # Alpine APK
    log_info "Generating Alpine APK packages..."
    ./packaging/alpine/generate-apk.sh prefer-pnpm prefer
    ./packaging/alpine/generate-apk.sh eject-npm eject
    ./packaging/alpine/generate-apk.sh force-pnpm force
    ./packaging/alpine/generate-apk.sh block-npm block

    # Debian DEB
    log_info "Generating Debian DEB packages..."
    ./packaging/debian/generate-deb.sh prefer-pnpm prefer
    ./packaging/debian/generate-deb.sh eject-npm eject
    ./packaging/debian/generate-deb.sh force-pnpm force
    ./packaging/debian/generate-deb.sh block-npm block

    # Fedora RPM
    log_info "Generating Fedora RPM packages..."
    ./packaging/fedora/generate-rpm.sh prefer-pnpm prefer
    ./packaging/fedora/generate-rpm.sh eject-npm eject
    ./packaging/fedora/generate-rpm.sh force-pnpm force
    ./packaging/fedora/generate-rpm.sh block-npm block

    # Arch PKGBUILD
    log_info "Generating Arch PKGBUILD packages..."
    ./packaging/arch/generate-pkgbuild.sh prefer-pnpm prefer
    ./packaging/arch/generate-pkgbuild.sh eject-npm eject
    ./packaging/arch/generate-pkgbuild.sh force-pnpm force
    ./packaging/arch/generate-pkgbuild.sh block-npm block

    # Homebrew Formula
    log_info "Generating Homebrew formulas..."
    ./packaging/brew/generate-formula.rb prefer-pnpm prefer
    ./packaging/brew/generate-formula.rb eject-npm eject
    ./packaging/brew/generate-formula.rb force-pnpm force
    ./packaging/brew/generate-formula.rb block-npm block

    # mise plugins
    log_info "Generating mise plugins..."
    ./packaging/mise/generate-mise-plugins.sh prefer-pnpm prefer
    ./packaging/mise/generate-mise-plugins.sh eject-npm eject
    ./packaging/mise/generate-mise-plugins.sh force-pnpm force
    ./packaging/mise/generate-mise-plugins.sh block-npm block

    log_end "All packaging generated successfully"

[private]
clean_impl:
    #!/usr/bin/env bash
    set -euo pipefail
    {{_log}}
    log_start "Cleaning build artifacts"
    rm -rf result
    rm -rf packaging/*/*/BUILD
    rm -rf packaging/*/*/RPMS
    rm -rf packaging/*/*/SRPMS
    rm -rf packaging/*/*/*.tar.gz
    rm -rf packaging/*/*/*.deb
    rm -rf packaging/*/*/*.rpm
    rm -rf packaging/*/*/*.pkg.tar.zst
    log_end "Build artifacts cleaned"
