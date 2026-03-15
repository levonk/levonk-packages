#!/bin/bash
set -euo pipefail

# Generate complete package list for documentation

cat > docs/PACKAGE_LIST.md << 'EOF'
# Complete Package List

This document lists all available governance packages in the Command Preference & Package Governance System.

## npm Governance Packages

### npm → pnpm
- **`prefer-pnpm`** - Warn and delegate to pnpm
- **`eject-npm`** - Remove npm and block future installs  
- **`force-pnpm`** - Replace npm with pnpm transparently
- **`block-npm`** - Block npm execution entirely

### npm → yarn
- **`prefer-yarn`** - Warn and delegate to yarn
- **`eject-yarn`** - Remove npm and block future installs
- **`force-yarn`** - Replace npm with yarn transparently  
- **`block-yarn`** - Block npm execution entirely

### npm → bun
- **`prefer-bun`** - Warn and delegate to bun
- **`eject-bun`** - Remove npm and block future installs
- **`force-bun`** - Replace npm with bun transparently
- **`block-bun`** - Block npm execution entirely

## pnpm Governance Packages

### pnpm → npm
- **`prefer-npm`** - Warn and delegate to npm
- **`eject-pnpm`** - Remove pnpm and block future installs
- **`force-npm`** - Replace pnpm with npm transparently
- **`block-pnpm`** - Block pnpm execution entirely

### pnpm → yarn
- **`prefer-yarn-from-pnpm`** - Warn and delegate to yarn
- **`eject-yarn-from-pnpm`** - Remove pnpm and block future installs
- **`force-yarn-from-pnpm`** - Replace pnpm with yarn transparently
- **`block-yarn-from-pnpm`** - Block pnpm execution entirely

### pnpm → bun
- **`prefer-bun-from-pnpm`** - Warn and delegate to bun
- **`eject-bun-from-pnpm`** - Remove pnpm and block future installs
- **`force-bun-from-pnpm`** - Replace pnpm with bun transparently
- **`block-bun-from-pnpm`** - Block pnpm execution entirely

## yarn Governance Packages

### yarn → npm
- **`prefer-npm-from-yarn`** - Warn and delegate to npm
- **`eject-npm-from-yarn`** - Remove yarn and block future installs
- **`force-npm-from-yarn`** - Replace yarn with npm transparently
- **`block-npm-from-yarn`** - Block yarn execution entirely

### yarn → pnpm
- **`prefer-pnpm-from-yarn`** - Warn and delegate to pnpm
- **`eject-pnpm-from-yarn`** - Remove yarn and block future installs
- **`force-pnpm-from-yarn`** - Replace yarn with pnpm transparently
- **`block-pnpm-from-yarn`** - Block yarn execution entirely

### yarn → bun
- **`prefer-bun-from-yarn`** - Warn and delegate to bun
- **`eject-bun-from-yarn`** - Remove yarn and block future installs
- **`force-bun-from-yarn`** - Replace yarn with bun transparently
- **`block-bun-from-yarn`** - Block yarn execution entirely

## bun Governance Packages

### bun → npm
- **`prefer-npm-from-bun`** - Warn and delegate to npm
- **`eject-npm-from-bun`** - Remove bun and block future installs
- **`force-npm-from-bun`** - Replace bun with npm transparently
- **`block-npm-from-bun`** - Block bun execution entirely

### bun → pnpm
- **`prefer-pnpm-from-bun`** - Warn and delegate to pnpm
- **`eject-pnpm-from-bun`** - Remove bun and block future installs
- **`force-pnpm-from-bun`** - Replace bun with pnpm transparently
- **`block-pnpm-from-bun`** - Block bun execution entirely

### bun → yarn
- **`prefer-yarn-from-bun`** - Warn and delegate to yarn
- **`eject-yarn-from-bun`** - Remove bun and block future installs
- **`force-yarn-from-bun`** - Replace bun with yarn transparently
- **`block-yarn-from-bun`** - Block bun execution entirely

## pip Governance Packages

### pip → uv
- **`prefer-uv`** - Warn and delegate to uv
- **`eject-pip`** - Remove pip and block future installs
- **`block-pip`** - Block pip execution entirely

## Tool Preference Packages

### Environment Setup
- **`prefer-devbox`** - Guide away from curl for environment setup

### Package Manager Management
- **`prefer-corepack`** - Guide toward corepack for package manager management

## Bundle Package

- **`command-governance`** - All governance packages in one bundle

## Total Package Count

- **Individual packages**: 47 governance packages
- **Bundle packages**: 1
- **Total**: 48 packages

## Usage Patterns

### Common Migration Scenarios

#### Migrate from npm to pnpm
```bash
# Start with gentle guidance
devbox add github:levonk/levonk-packages#prefer-pnpm

# Upgrade to strict enforcement
devbox add github:levonk/levonk-packages#force-pnpm

# Complete block
devbox add github:levonk/levonk-packages#block-npm
```

#### Migrate from yarn to pnpm
```bash
# Start with guidance
devbox add github:levonk/levonk-packages#prefer-pnpm-from-yarn

# Strict replacement
devbox add github:levonk/levonk-packages#force-pnpm-from-yarn

# Complete block
devbox add github:levonk/levonk-packages#block-yarn-from-pnpm
```

#### Comprehensive Governance
```bash
# Install all governance at once
devbox add github:levonk/levonk-packages#command-governance
```

## Package Naming Convention

The naming convention follows this pattern:
- **`{target}-{behavior}`** - For npm governance (e.g., `prefer-pnpm`)
- **`{target}-{behavior}-from-{source}`** - For cross-tool governance (e.g., `prefer-pnpm-from-yarn`)

Where:
- **`target`** - The binary being governed (npm, pnpm, yarn, bun, pip)
- **`behavior`** - prefer, eject, force, block
- **`source`** - The source tool when different from target
EOF

echo "Generated complete package list!"
