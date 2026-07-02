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

### RTK Token Optimization Wrappers

**Install individual RTK wrapper**:
```bash
# Via Nix
nix profile install .#rtk-wrap-ls

# Via Devbox
devbox add github:levonk/levonk-packages#rtk-wrap-ls

# Install complete RTK suite
nix profile install .#bundle-rtk-all
devbox add github:levonk/levonk-packages#bundle-rtk-all
```

**Usage**:
```bash
# Commands automatically run through RTK for token optimization
ls -la          # → rtk ls -la (compact output)
git status      # → rtk git status (compact output)
npm install     # → rtk npm install (filtered output)
```

### Devbox Auto-Environment Management

**Install devbox-auto wrapper**:
```bash
# Via Nix
nix profile install .#devbox-auto-npm

# Via Devbox
devbox add github:levonk/levonk-packages#devbox-auto-npm

# Install complete devbox-auto suite
nix profile install .#bundle-devbox-auto-all
devbox add github:levonk/levonk-packages#bundle-devbox-auto-all
```

**Usage**:
```bash
# Commands automatically ensure tools via devbox
npm install     # → Adds npm to devbox.json → devbox run -- npm install
python script.py  # → Adds python to devbox.json → devbox run -- python script.py
```

### Integrated Devbox-RTK-Governance Packages

**Install integrated package (environment + optimization + governance)**:
```bash
# Via Nix
nix profile install .#devbox-rtk-nodejs-pnpm-force

# Via Devbox
devbox add github:levonk/levonk-packages#devbox-rtk-nodejs-pnpm-force
```

**Usage**:
```bash
# npm → pnpm (force) + devbox environment + RTK optimization
npm install
# → ✅ Using pnpm instead of npm (forced by policy)...
# → 📦 Adding pnpm to devbox environment...
# → devbox run -- rtk pnpm install
```

### Traditional Governance Packages

**Note**: Nix/Devbox packages work immediately. Other package managers require running `just generate` first.

##### With Devbox (Recommended)

```bash
# Add npm governance
devbox add github:levonk/levonk-packages#prefer-pnpm

# Add comprehensive governance
devbox add github:levonk/levonk-packages#command-governance

# Your existing workflow continues unchanged
npm install  # Now governed by pnpm
```

#### With Nix

```bash
# Build locally from source
nix build .#prefer-pnpm
nix build .#command-governance

# Run governed commands
nix run .#prefer-pnpm -- --version

# Install to profile
nix profile install .#prefer-pnpm
nix profile install .#command-governance
```

### Other Package Managers

```bash
# First generate packages
git clone https://github.com/levonk/levonk-packages.git
cd levonk-packages
just generate

# Then install via your preferred package manager
# Example for Alpine:
apk add command-prefer-pnpm
```

## 📦 Available Packages

### Integrated Devbox-RTK-Governance Packages (16 packages)
- **Node.js with pnpm**: `devbox-rtk-nodejs-pnpm-prefer`, `devbox-rtk-nodejs-pnpm-force`, `devbox-rtk-nodejs-pnpm-block`, `devbox-rtk-nodejs-pnpm-native`
- **Node.js with yarn**: `devbox-rtk-nodejs-yarn-prefer`, `devbox-rtk-nodejs-yarn-force`, `devbox-rtk-nodejs-yarn-block`, `devbox-rtk-nodejs-yarn-native`
- **Node.js with bun**: `devbox-rtk-nodejs-bun-prefer`, `devbox-rtk-nodejs-bun-force`, `devbox-rtk-nodejs-bun-block`, `devbox-rtk-nodejs-bun-native`
- **Python with uv**: `devbox-rtk-python-uv-prefer`, `devbox-rtk-python-uv-force`, `devbox-rtk-python-uv-block`, `devbox-rtk-python-uv-native`


### Devbox Auto-Environment Management (8 packages)
- **Node.js**: `devbox-auto-npm`, `devbox-auto-pnpm`, `devbox-auto-yarn`
- **Python**: `devbox-auto-python`, `devbox-auto-pip`
- **Rust**: `devbox-auto-cargo`, `devbox-auto-rustc`
- **Go**: `devbox-auto-go`

**Bundle Devbox Packages**:
- `bundle-devbox-auto-nodejs` - Node.js package managers
- `bundle-devbox-auto-python` - Python tools
- `bundle-devbox-auto-rust` - Rust toolchain
- `bundle-devbox-auto-go` - Go tools
- `bundle-devbox-auto-all` - All devbox-auto wrappers

### RTK Token Optimization Wrappers (54 packages)

**Bundle RTK Packages**:
- `bundle-rtk-core` - Core command wrappers
- `bundle-rtk-development` - Development tool wrappers
- `bundle-rtk-cloud` - Cloud tool wrappers
- `bundle-rtk-all` - All 54 RTK wrapper packages

- **Core Commands**: `rtk-wrap-ls`, `rtk-wrap-tree`, `rtk-wrap-cat`, `rtk-wrap-find`, `rtk-wrap-grep`, `rtk-wrap-diff`, `rtk-wrap-wc`, `rtk-wrap-curl`, `rtk-wrap-json`, `rtk-wrap-env`, `rtk-wrap-deps`, `rtk-wrap-test`, `rtk-wrap-err`
- **Development Tools**: `rtk-wrap-git`, `rtk-wrap-npm`, `rtk-wrap-npx`, `rtk-wrap-pnpm`, `rtk-wrap-tsc`, `rtk-wrap-jest`, `rtk-wrap-vitest`, `rtk-wrap-pytest`, `rtk-wrap-mypy`, `rtk-wrap-ruff`, `rtk-wrap-prettier`, `rtk-wrap-eslint`, `rtk-wrap-prisma`, `rtk-wrap-next`, `rtk-wrap-lint`, `rtk-wrap-format`, `rtk-wrap-playwright`, `rtk-wrap-cargo`, `rtk-wrap-pip`, `rtk-wrap-go`, `rtk-wrap-golangci-lint`, `rtk-wrap-rubocop`, `rtk-wrap-rake`, `rtk-wrap-rspec`, `rtk-wrap-gradlew`
- **Cloud & DevOps**: `rtk-wrap-gh`, `rtk-wrap-glab`, `rtk-wrap-docker`, `rtk-wrap-kubectl`, `rtk-wrap-oc`, `rtk-wrap-aws`, `rtk-wrap-psql`, `rtk-wrap-dotnet`, `rtk-wrap-wget`, `rtk-wrap-gt`

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

### nub Governance (17 packages, depend on `github:nubjs/nub`)
- **all → nub (consolidated)**: `prefer-nub`, `force-nub`, `block-nub`, `eject-nub`
- **npm → nub**: `force-nub-from-npm`
- **pnpm → nub**: `prefer-nub-from-pnpm`, `force-nub-from-pnpm`, `block-nub-from-pnpm`, `eject-nub-from-pnpm`
- **yarn → nub**: `prefer-nub-from-yarn`, `force-nub-from-yarn`, `block-nub-from-yarn`, `eject-nub-from-yarn`
- **bun → nub**: `prefer-nub-from-bun`, `force-nub-from-bun`, `block-nub-from-bun`, `eject-nub-from-bun`

> `force-nub*` packages install nub from `github:nubjs/nub` (compiled from source). `prefer-nub*`/`block-nub*`/`eject-nub*` do not install nub — it must already be on PATH.

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

**Total: 289 individual governance packages + 19 bundle packages = 308 packages**

📖 **See [docs/PACKAGE_LIST.md](docs/PACKAGE_LIST.md) for the complete detailed list.**

## 🔧 New Features

### 🔄 Automated RTK Command Sync

Keep RTK wrapper packages synchronized with the official RTK README automatically:

```bash
# Run the sync workflow (requires Archon CLI)
bun run cli workflow run sync-rtk-commands
```

**Workflow location**: `.agents/workflows/sync-rtk-commands.yaml` (also in `.devin/workflows/`)

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

## 🔗 Stacking Packages & Avoiding Collisions

Each governance package wraps one or more binaries (e.g. `npm`, `pnpm`, `yarn`, `bun`). When you install multiple packages that wrap the **same** binary, they collide — whichever lands last in PATH wins, and the result is unpredictable. The rule is simple:

> **Each binary should be wrapped by exactly one package.**

### How consolidated packages work

The main `prefer-{tool}` and `force-{tool}` packages are **consolidated** — each wraps all rival tools in one install:

| Package | Wraps | Redirects to |
|---|---|---|
| `prefer-nub` / `force-nub` | npm, pnpm, yarn, bun | nub |
| `prefer-pnpm` / `force-pnpm` | npm, yarn, bun | pnpm |
| `prefer-yarn` / `force-yarn` | npm, pnpm, bun | yarn |
| `prefer-bun` / `force-bun` | npm, pnpm, yarn | bun |
| `prefer-npm` / `force-npm` | pnpm, yarn, bun | npm |

Note: `prefer-pnpm`/`force-pnpm`/etc. do **not** wrap nub — nub is the superset tool, and users on nub shouldn't be downgraded.

### Don't stack consolidated packages

Installing `prefer-nub` + `force-nub` is pointless — force wins, prefer is dead weight. Installing `force-pnpm` + `force-nub` is broken — both wrap `npm`, `yarn`, and `bun`, so they collide.

### Do: mix governance modes per tool with `from-*` building blocks

The `*-from-{tool}` packages wrap a **single** binary, so they compose without collisions. This lets you apply different governance modes to different tools:

```bash
# pnpm: polite suggestion to use nub (warns but falls back to pnpm)
nix profile install github:levonk/levonk-packages#prefer-nub-from-pnpm

# npm, yarn, bun: hard redirect to nub (no escape)
nix profile install github:levonk/levonk-packages#force-nub-from-npm
nix profile install github:levonk/levonk-packages#force-nub-from-yarn
nix profile install github:levonk/levonk-packages#force-nub-from-bun
```

Each package wraps exactly one binary — no collisions:

| Package | Wraps | Mode |
|---|---|---|
| `prefer-nub-from-pnpm` | `pnpm` only | warns → nub, falls back to pnpm |
| `force-nub-from-npm` | `npm` only | hard → nub |
| `force-nub-from-yarn` | `yarn` only | hard → nub |
| `force-nub-from-bun` | `bun` only | hard → nub |

### Don't: add `force-pnpm` to the above combo

`force-pnpm` wraps `npm`, `yarn`, and `bun` — the same binaries already wrapped by `force-nub-from-npm`/`yarn`/`bun`. Adding it reintroduces collisions. If pnpm should be left alone (only nudged toward nub), `prefer-nub-from-pnpm` already handles that.

### Quick reference: valid combos

| Goal | Install |
|---|---|
| Everything → pnpm, hard | `force-pnpm` (one package) |
| Everything → nub, hard | `force-nub` (one package) |
| Everything → nub, polite | `prefer-nub` (one package) |
| pnpm polite, rest forced → nub | `prefer-nub-from-pnpm` + `force-nub-from-npm` + `force-nub-from-yarn` + `force-nub-from-bun` |
| npm blocked, rest → pnpm | `block-npm` + `force-pnpm-from-yarn` + `force-pnpm-from-bun` |

### nub packages and the nub flake

- **`force-nub*` packages** pull nub from [`github:nubjs/nub`](https://github.com/nubjs/nub) as a flake input — nub is compiled from source (Rust) and the wrapper execs the store-path binary.
- **`prefer-nub*`, `block-nub*`, `eject-nub*` packages** do **not** install nub — they use `command -v nub` (PATH lookup) or just print an error. nub must already be on PATH.

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
- **289 individual governance packages tested** (115 existing + 92 devbox reminder + 54 RTK wrapper + 8 devbox-auto + 16 devbox-rtk-governance)
- **19 bundle packages tested** (11 existing + 4 RTK bundle + 4 devbox-auto bundle)
- **303 test scenarios total**
- **Transient devbox environments** for isolation
- **Behavioral validation** for all governance types

### Test Examples
```bash
# Test traditional governance packages
nix run .#prefer-pnpm -- --version
nix run .#block-npm -- --version  # Exits with error

# Test RTK wrapper packages
nix run .#rtk-wrap-ls -- --version
nix run .#rtk-wrap-git -- --version

# Test devbox-auto packages
nix run .#devbox-auto-npm -- --version

# Test integrated devbox-rtk packages
nix run .#devbox-rtk-nodejs-pnpm-force -- --version

# Test bundle packages
nix build .#nodejs-ecosystem
nix build .#python-ecosystem
nix build .#dev-tools
nix build .#migrate-to-pnpm
nix build .#migrate-to-uv
nix build .#bundle-rtk-all
nix build .#bundle-devbox-auto-all
```

## 🔧 Installation

### Package Managers

**Note**: Traditional governance packages must be generated first with `just generate` from this repository. RTK, devbox-auto, and integrated packages work immediately via Nix/Devbox.

| Manager | Command |
|---------|---------|
| **Devbox** | `devbox add github:levonk/levonk-packages#prefer-pnpm` |
| **Nix** | `nix profile install .#prefer-pnpm` |
| **Nix (build)** | `nix build .#prefer-pnpm` |
| **Alpine** | `apk add command-prefer-pnpm` *(after generation)* |
| **Debian/Ubuntu** | `sudo apt install command-prefer-pnpm` *(after generation)* |
| **Fedora** | `sudo dnf install command-prefer-pnpm` *(after generation)* |
| **Arch** | `yay -S command-prefer-pnpm` *(after generation)* |
| **Homebrew** | `brew install command-prefer-pnpm` *(after generation)* |
| **mise** | `mise use prefer-pnpm` *(after generation)* |

### Installation Examples

#### RTK Token Optimization Wrappers
```bash
# Install individual RTK wrapper
nix profile install .#rtk-wrap-ls
devbox add github:levonk/levonk-packages#rtk-wrap-ls

# Install complete RTK suite
nix profile install .#bundle-rtk-all
devbox add github:levonk/levonk-packages#bundle-rtk-all
```

#### Devbox Auto-Environment Management
```bash
# Install individual devbox-auto wrapper
nix profile install .#devbox-auto-npm
devbox add github:levonk/levonk-packages#devbox-auto-npm

# Install complete devbox-auto suite
nix profile install .#bundle-devbox-auto-all
devbox add github:levonk/levonk-packages#bundle-devbox-auto-all
```

#### Integrated Devbox-RTK-Governance Packages
```bash
# Install integrated package (environment + optimization + governance)
nix profile install .#devbox-rtk-nodejs-pnpm-force
devbox add github:levonk/levonk-packages#devbox-rtk-nodejs-pnpm-force
```

#### Traditional Governance Packages
```bash
# Install traditional governance package
nix profile install .#prefer-pnpm
devbox add github:levonk/levonk-packages#prefer-pnpm

# Install comprehensive governance bundle
nix profile install .#command-governance
devbox add github:levonk/levonk-packages#command-governance
```

### Generate All Packages

```bash
# Generate packages for all ecosystems
just generate

# Or generate specific ecosystems
just generate-internal
```

### Development Setup

```bash
# Clone repository
git clone https://github.com/levonk/levonk-packages.git
cd levonk-packages

# Bootstrap development environment
just bootstrap

# Build all packages
just build

# Generate packaging for all ecosystems
just generate

# Test functionality
just test
```

## 🏗️ Architecture

See [docs/SPEC.md](docs/SPEC.md) for the behavioral model, dependency graph, and cross-ecosystem support.

Packages use shared Nix libraries in `nix/lib/` that inline utility scripts at build time. See [AGENTS.md](AGENTS.md) for wrapper-authoring guidance.

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
3. See [AGENTS.md](AGENTS.md) for wrapper-authoring guidance (shared Nix libraries in `nix/lib/`)
4. Test with `just test`
5. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🔗 Related Projects

- [Standard Developer UX Flow](https://github.com/lrepo52/job-aide/blob/main/internal-docs/adr/adr-20260131001-standard-developer-ux-flow.md)
- [Devbox](https://www.jetify.com/devbox/)
- [just](https://github.com/casey/just)
- [Nix](https://nixos.org/)
