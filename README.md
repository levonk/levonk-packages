# Command Preference & Package Governance System

A unified, cross-ecosystem system for command preference and package governance that works seamlessly with your existing development workflow.

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

### npm Governance
- **`prefer-pnpm`** - Warn and delegate to pnpm
- **`eject-npm`** - Remove npm and block future installs
- **`force-pnpm`** - Replace npm with pnpm transparently
- **`block-npm`** - Block npm execution entirely

### pip Governance
- **`prefer-uv`** - Warn and delegate to uv
- **`eject-pip`** - Remove pip and block future installs
- **`block-pip`** - Block pip execution entirely

### Tool Preferences
- **`prefer-devbox`** - Guide away from curl for environment setup
- **`prefer-corepack`** - Guide toward corepack for package manager management

### Bundle Package
- **`command-governance`** - All governance packages in one

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
