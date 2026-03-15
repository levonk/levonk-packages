# Command Preference & Package Governance System

**Technical Specification – Unified Multi‑Package‑Manager Architecture**

## Purpose

This repository provides a unified, cross‑ecosystem system for:

1. **Command Preference Micro‑Packages**  
   Small, composable packages that override developer commands (e.g., `npm`, `pip`, `curl`) with policy‑aware wrappers.

2. **Package Governance**  
   A mechanism to:
   - Prefer a tool (`prefer-*`)
   - Force a tool (`force-*`)
   - Block a tool (`block-*`)
   - Remove + block installation of a tool (`eject-*`)

3. **Cross‑Package‑Manager Installation**  
   The same micro‑packages can be installed via:
   - Nix (flakes, Devbox, home‑manager, NixOS)
   - Alpine (APK)
   - Debian/Ubuntu (APT/DEB)
   - Fedora (RPM)
   - Arch (PKGBUILD)
   - Homebrew (Formula)
   - mise (plugin shims)

4. **Alignment with the Standard Developer UX Flow (Devbox‑First)**  
   The system integrates cleanly with the ADR-defined workflow:
   - `direnv → devbox → just (*-internal) → cargo`

## Behavioral Model

### `prefer-*` (soft guidance)
- Warns when the disfavored tool is used.
- Delegates to the preferred tool **if installed**.
- Does **not** install the preferred tool.
- Does **not** remove or block the disfavored tool.
- Does **not** depend on `eject-*`.

Use case: multi‑project environments, gradual migration.

### `eject-*` (enforcement engine)
- Removes the disfavored tool **if possible**.
- Blocks future installation of the disfavored tool.
- Shadows the binary with a wrapper.
- Does **not** install any replacement.
- Provides cross‑ecosystem enforcement.

If removal is impossible (e.g., npm bundled with nodejs), `eject-*` shadows the binary and blocks future installs.

### `force-*` (strict replacement)
- **Depends on `eject-*`**
- Installs the preferred tool.
- Replaces the disfavored tool with a wrapper that delegates to the preferred tool.
- Guarantees deterministic behavior.

Example: `force-pnpm`:
- Removes npm (via eject-npm)
- Installs pnpm
- Replaces `npm` with a wrapper that runs pnpm

### `block-*` (strict prohibition)
- **Depends on `eject-*`**
- Does **not** install any replacement.
- Replaces the disfavored tool with a wrapper that exits with error.

Example: `block-pip`:
- Removes pip (via eject-pip)
- Blocks future pip installs
- Replaces `pip` with a wrapper that prints a message and exits 1

## Dependency Graph

```
prefer-*     (no dependency)
force-*  →   eject-*
block-*  →   eject-*
eject-*      (base layer)
```

This ensures:
- No duplication of removal logic
- No duplication of conflict metadata
- Clean layering
- Predictable behavior across all ecosystems

## Repository Layout

```
.
├── flake.nix
├── wrappers/
│   ├── npm.prefer-pnpm.sh
│   ├── npm.force-pnpm.sh
│   ├── npm.block-npm.sh
│   ├── npm.eject-npm.sh
│   ├── pip.prefer-uv.sh
│   ├── pip.block-pip.sh
│   ├── pip.eject-pip.sh
│   ├── curl.prefer-devbox.sh
│   └── node.prefer-corepack.sh
├── nix/
│   ├── prefer-pnpm.nix
│   ├── force-pnpm.nix
│   ├── block-npm.nix
│   ├── eject-npm.nix
│   ├── prefer-uv.nix
│   ├── block-pip.nix
│   ├── eject-pip.nix
│   ├── prefer-devbox.nix
│   ├── prefer-corepack.nix
│   └── bundle-command-governance.nix
├── packaging/
│   ├── alpine/generate-apk.sh
│   ├── debian/generate-deb.sh
│   ├── fedora/generate-rpm.sh
│   ├── arch/generate-pkgbuild.sh
│   ├── brew/generate-formula.rb
│   └── mise/generate-mise-plugins.sh
├── devbox.json
├── justfile
└── docs/
    ├── SPEC.md
    └── ADR-devbox-ux.md
```

## Installation

### Nix / Devbox

```bash
# Install individual packages
devbox add github:levonk/levonk-packages#prefer-pnpm
devbox add github:levonk/levonk-packages#command-governance

# Or build locally
nix build .#prefer-pnpm
nix build .#command-governance
```

### Alpine (APK)

```bash
apk add command-prefer-pnpm
apk add eject-npm
apk add force-pnpm
apk add block-npm
```

### Debian/Ubuntu (APT)

```bash
sudo apt install command-prefer-pnpm
sudo apt install eject-npm
sudo apt install force-pnpm
sudo apt install block-npm
```

### Fedora (RPM)

```bash
sudo dnf install command-prefer-pnpm
sudo dnf install eject-npm
sudo dnf install force-pnpm
sudo dnf install block-npm
```

### Arch (PKGBUILD)

```bash
yay -S command-prefer-pnpm
yay -S eject-npm
yay -S force-pnpm
yay -S block-npm
```

### Homebrew

```bash
brew install command-prefer-pnpm
brew install eject-npm
brew install force-pnpm
brew install block-npm
```

### mise

```bash
mise plugin install prefer-pnpm https://github.com/levonk/levonk-packages
mise use prefer-pnpm
```

## Development

### Prerequisites

- Nix with flakes enabled
- Devbox (for development environment)
- just (command runner)

### Getting Started

```bash
# Clone repository
git clone https://github.com/levonk/levonk-packages.git
cd levonk-packages

# Bootstrap development environment
just bootstrap

# Build all packages
just build

# Test package functionality
just test

# Generate packaging for all ecosystems
just generate
```

### Available Commands

```bash
just build      # Build all Nix packages
just test       # Test package functionality
just generate   # Generate packaging for different ecosystems
just install    # Show installation examples
just doctor     # Check environment health
just clean      # Clean build artifacts
```

## Usage Examples

### Gradual Migration with `prefer-pnpm`

```bash
# Install prefer-pnpm
devbox add github:levonk/levonk-packages#prefer-pnpm

# Now npm commands warn and delegate to pnpm
npm install
# ⚠️ Prefer pnpm over npm. Running pnpm instead...
# [pnpm output continues]
```

### Strict Enforcement with `force-pnpm`

```bash
# Install force-pnpm (includes eject-npm)
devbox add github:levonk/levonk-packages#force-pnpm

# Now npm commands are transparently redirected to pnpm
npm install
# ✅ Using pnpm instead of npm (forced by policy)...
# [pnpm output continues]
```

### Complete Block with `block-npm`

```bash
# Install block-npm (includes eject-npm)
devbox add github:levonk/levonk-packages#block-npm

# Now npm commands are blocked
npm install
# ❌ npm is blocked by policy. Use pnpm or corepack instead.
# Exit 1
```

## Integration with Standard Developer UX Flow

This system is designed to work seamlessly with the Devbox-first developer workflow:

- **direnv** automatically activates the Devbox environment
- **devbox** provides the governed commands
- **just** orchestrates build, test, and development tasks
- **All governance packages** integrate without disrupting the flow

See `docs/ADR-devbox-ux.md` for the complete ADR integration.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add new wrapper scripts in `wrappers/`
4. Create corresponding Nix derivations in `nix/`
5. Update packaging generators as needed
6. Test with `just test`
7. Submit a pull request

## License

MIT License - see LICENSE file for details.
