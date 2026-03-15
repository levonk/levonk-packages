# Command Preference & Package Governance System

**AI Agent Harness for Preferred Tooling Governance**

This repository provides a unified system for AI agents to stay within preferred tooling boundaries while maintaining developer productivity. It serves as a **harness for automated systems** to enforce tooling policies without breaking existing workflows.

## 🎯 Purpose

### Primary: AI Agent Governance
- **Enforce tooling preferences** for AI agents and automated systems
- **Prevent tool drift** in automated code generation and management
- **Provide clear guidance** when agents attempt to use disfavored tools
- **Maintain consistency** across AI-assisted development workflows

### Secondary: Developer Tool Governance
- **Gradual migration** support for teams adopting new tooling standards
- **Multi-project environments** where different projects use different tools
- **Policy enforcement** for organizations with specific tooling requirements
- **Educational guidance** for developers learning new tooling ecosystems

## 🚀 Quick Start

### With Devbox (Recommended)

```bash
# Add npm governance
devbox add github:levonk/levonk-packages#prefer-pnpm

# Add comprehensive governance
devbox add github:levonk/levonk-packages#command-governance

# Your existing workflow continues unchanged
npm install  # Now governed by pnpm
```

### With Nix

```bash
# Build locally
nix build .#prefer-pnpm
nix build .#command-governance

# Run governed commands
nix run .#prefer-pnpm -- --version
```

## 📦 Available Packages

### npm Governance (12 packages)
- **npm → pnpm**: `prefer-pnpm`, `eject-npm`, `force-pnpm`, `block-npm`
- **npm → yarn**: `prefer-yarn`, `eject-yarn`, `force-yarn`, `block-yarn`
- **npm → bun**: `prefer-bun`, `eject-bun`, `force-bun`, `block-bun`

### pnpm Governance (15 packages)
- **pnpm → npm**: `prefer-npm`, `eject-pnpm`, `force-npm`, `block-pnpm`
- **pnpm → yarn**: `prefer-yarn-from-pnpm`, `eject-yarn-from-pnpm`, `force-yarn-from-pnpm`, `block-yarn-from-pnpm`
- **pnpm → bun**: `prefer-bun-from-pnpm`, `eject-bun-from-pnpm`, `force-bun-from-pnpm`, `block-bun-from-pnpm`

### yarn Governance (12 packages)
- **yarn → npm**: `prefer-npm-from-yarn`, `eject-npm-from-yarn`, `force-npm-from-yarn`, `block-npm-from-yarn`
- **yarn → pnpm**: `prefer-pnpm-from-yarn`, `eject-pnpm-from-yarn`, `force-pnpm-from-yarn`, `block-pnpm-from-yarn`
- **yarn → bun**: `prefer-bun-from-yarn`, `eject-bun-from-yarn`, `force-bun-from-yarn`, `block-bun-from-yarn`

### bun Governance (12 packages)
- **bun → npm**: `prefer-npm-from-bun`, `eject-npm-from-bun`, `force-npm-from-bun`, `block-npm-from-bun`
- **bun → pnpm**: `prefer-pnpm-from-bun`, `eject-pnpm-from-bun`, `force-pnpm-from-bun`, `block-pnpm-from-bun`
- **bun → yarn**: `prefer-yarn-from-bun`, `eject-yarn-from-bun`, `force-yarn-from-bun`, `block-yarn-from-bun`

### pip Governance (3 packages)
- **pip → uv**: `prefer-uv`, `eject-pip`, `block-pip`

### Tool Preferences (2 packages)
- **Environment setup**: `prefer-devbox`
- **Package manager management**: `prefer-corepack`

### Logical Bundle Packages (5 packages)
- **`nodejs-ecosystem`** - All Node.js package manager governance (npm/pnpm/yarn/bun)
- **`python-ecosystem`** - Python package manager governance (pip/uv)
- **`dev-tools`** - Development tool governance (curl/devbox)
- **`migrate-to-pnpm-bundle`** - Complete npm→pnpm migration bundle
- **`migrate-to-uv-bundle`** - Complete pip→uv migration bundle

### Individual Force Packages
- **`force-uv`** - Individual package that forces pip→uv (as defined in specs)
- **`force-pnpm`** - Individual package that forces npm→pnpm
- **`force-devbox`** - Individual package that forces curl→devbox

### Legacy Bundle Package
- **`command-governance`** - All 47 governance packages in one bundle

**Note**: `force-uv` is an individual package (per specs), while `migrate-to-uv-bundle` is a convenience bundle that includes `force-uv` + `eject-pip` + `prefer-uv` for complete migration scenarios.

**Total: 49 individual governance packages + 6 bundle packages = 55 packages**

📖 **See [docs/PACKAGE_LIST.md](docs/PACKAGE_LIST.md) for the complete detailed list.**

## 🔧 New Features

### 🎯 Dynamic Package Detection
All `prefer-*` wrappers now intelligently detect available alternatives on your system:

```bash
npm install
# ⚠️ Prefer pnpm over npm. Detecting available alternatives...
# ✅ Using pnpm (preferred)
# ℹ️  yarn is also available
# ℹ️  bun is also available
# 💡 Tip: Multiple alternatives detected. Consider standardizing on pnpm for best compatibility.
```

### 📦 Logical Bundle Packages
New logical bundles organized by tool categories:

```bash
# Node.js ecosystem governance
devbox add github:levonk/levonk-packages#nodejs-ecosystem

# Python ecosystem governance  
devbox add github:levonk/levonk-packages#python-ecosystem

# Development tool guidance
devbox add github:levonk/levonk-packages#dev-tools

# Complete migration scenarios
devbox add github:levonk/levonk-packages#migrate-to-pnpm
devbox add github:levonk/levonk-packages#migrate-to-uv
```

## 🎯 Use Cases

### Gradual Migration
```bash
# Start with gentle guidance
devbox add github:levonk/levonk-packages#prefer-pnpm

# npm commands now warn but still work
npm install
# ⚠️ Prefer pnpm over npm. Running pnpm instead...
```

### Strict Enforcement
```bash
# Upgrade to strict replacement
devbox add github:levonk/levonk-packages#force-pnpm

# npm commands transparently use pnpm
npm install
# ✅ Using pnpm instead of npm (forced by policy)...
```

### Complete Block
```bash
# Block disallowed tools entirely
devbox add github:levonk/levonk-packages#block-npm

# npm commands are blocked
npm install
# ❌ npm is blocked by policy. Use pnpm or corepack instead.
```

## 🧪 Testing

### Quick Tests
```bash
# Run basic functionality tests
just test

# Run comprehensive test suite
just test-comprehensive

# Test individual packages
just test-internal
```

### Test Coverage
- **13 individual governance packages** tested
- **4 bundle packages** tested
- **17 test scenarios** total
- **Transient devbox environments** for isolation
- **Behavioral validation** for all four governance types

### Test Examples
```bash
# Test prefer-pnpm behavior
nix run .#prefer-pnpm -- --version

# Test block-npm behavior
nix run .#block-npm -- --version  # Exits with error

# Test bundle packages
nix build .#nodejs-ecosystem
nix build .#python-ecosystem
nix build .#dev-tools
nix build .#migrate-to-pnpm
nix build .#migrate-to-uv
```

## 🔧 Installation

### Package Managers

| Manager | Command |
|---------|---------|
| **Devbox** | `devbox add github:levonk/levonk-packages#prefer-pnpm` |
| **Nix** | `nix build .#prefer-pnpm` |
| **Alpine** | `apk add command-prefer-pnpm` |
| **Debian/Ubuntu** | `sudo apt install command-prefer-pnpm` |
| **Fedora** | `sudo dnf install command-prefer-pnpm` |
| **Arch** | `yay -S command-prefer-pnpm` |
| **Homebrew** | `brew install command-prefer-pnpm` |
| **mise** | `mise use prefer-pnpm` |

### Development Setup

```bash
# Clone repository
git clone https://github.com/levonk/levonk-packages.git
cd levonk-packages

# Bootstrap development environment
just bootstrap

# Build all packages
just build

# Test functionality
just test

# Generate packaging for all ecosystems
just generate
```

## 🏗️ Architecture

### Behavioral Model

- **`prefer-*`** - Soft guidance with warnings and delegation
- **`eject-*`** - Remove tool and block future installation
- **`force-*`** - Strict replacement with preferred tool
- **`block-*`** - Complete prohibition with error exit

### Dependency Graph

```
prefer-*     (no dependency)
force-*  →   eject-*
block-*  →   eject-*
eject-*      (base layer)
```

### Cross-Ecosystem Support

The same micro-packages work across:
- Nix (flakes, Devbox, home-manager, NixOS)
- Alpine Linux (APK)
- Debian/Ubuntu (APT/DEB)
- Fedora (RPM)
- Arch Linux (PKGBUILD)
- Homebrew (Formula)
- mise (plugin shims)

## 🔄 Integration with Existing Workflows

This system integrates seamlessly with the Standard Developer UX Flow:

```
direnv → devbox → just (*-internal) → cargo
```

No changes to your existing workflow are required. Governance packages work like any other Devbox package.

### Example justfile (No Changes Needed)

```just
build:
    devbox shell build

test:
    devbox shell test

dev:
    devbox shell dev

# Internal targets work unchanged
build-internal:
    npm run build  # Automatically governed

test-internal:
    npm test      # Automatically governed
```

## 🧪 Testing

```bash
# Test individual packages
nix run .#prefer-pnpm -- --version
nix run .#block-npm -- --version  # Exits with error

# Test bundle package
nix build .#command-governance

# Test with Devbox
devbox add .#prefer-pnpm
npm --version  # Shows governance behavior
```

## 📚 Documentation

- **[Technical Specification](docs/SPEC.md)** - Complete technical details
- **[ADR Integration](docs/ADR-devbox-ux.md)** - Devbox workflow integration
- **[Requirements](docs/requirements/20260314-specs.md)** - Original requirements

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add wrapper scripts in `wrappers/`
4. Create Nix derivations in `nix/`
5. Update packaging generators
6. Test with `just test`
7. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🔗 Related Projects

- [Standard Developer UX Flow](https://github.com/lrepo52/job-aide/blob/main/internal-docs/adr/adr-20260131001-standard-developer-ux-flow.md)
- [Devbox](https://www.jetify.com/devbox/)
- [just](https://github.com/casey/just)
- [Nix](https://nixos.org/)
