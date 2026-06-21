# Devbox-RTK-Governance Packages

This directory contains integrated wrapper scripts that combine devbox environment management, RTK token optimization, and tool governance in a single coherent package.

## Purpose

When AI agents or developers run standard commands, these integrated wrappers automatically:
1. **Governance**: Route to preferred tool (npm → pnpm, pip → uv, etc.)
2. **Environment Management**: Ensure tools are available via devbox
3. **Token Optimization**: Run commands through RTK for compact output

## Why Integrated Packages?

**Problem with Separate Systems**:
- `prefer-pnpm` + `devbox-auto-npm` + `rtk-wrap-npm` = **Conflicting behavior**
- Multiple wrappers can interfere with each other
- Unclear which system takes precedence

**Solution with Integrated Packages**:
- `devbox-rtk-nodejs-pnpm-force` = **Single coherent package**
- Clear governance intent in package name
- No conflicts between systems
- Predictable behavior

## Package Naming Convention

```
devbox-rtk-{ecosystem}-{preferred-tool}-{governance-type}
```

**Examples**:
- `devbox-rtk-nodejs-pnpm-prefer` - Node.js ecosystem, prefer pnpm (soft guidance)
- `devbox-rtk-nodejs-pnpm-force` - Node.js ecosystem, force pnpm (strict replacement)
- `devbox-rtk-nodejs-pnpm-block` - Node.js ecosystem, block npm (error)
- `devbox-rtk-nodejs-pnpm-native` - Node.js ecosystem, use npm as-is (no governance)

## Available Integrated Packages

### Node.js Ecosystem

#### Pnpm Governance
- **`devbox-rtk-nodejs-pnpm-prefer`** - npm → pnpm (soft guidance + devbox + RTK)
- **`devbox-rtk-nodejs-pnpm-force`** - npm → pnpm (strict replacement + devbox + RTK)
- **`devbox-rtk-nodejs-pnpm-block`** - block npm (error + devbox + RTK)
- **`devbox-rtk-nodejs-pnpm-native`** - npm as-is (devbox + RTK, no governance)

#### Yarn Governance
- **`devbox-rtk-nodejs-yarn-prefer`** - npm/pnpm → yarn (soft guidance + devbox + RTK)
- **`devbox-rtk-nodejs-yarn-force`** - npm/pnpm → yarn (strict replacement + devbox + RTK)
- **`devbox-rtk-nodejs-yarn-block`** - block npm/pnpm (error + devbox + RTK)
- **`devbox-rtk-nodejs-yarn-native`** - npm/pnpm as-is (devbox + RTK, no governance)

#### Bun Governance
- **`devbox-rtk-nodejs-bun-prefer`** - npm/pnpm/yarn → bun (soft guidance + devbox + RTK)
- **`devbox-rtk-nodejs-bun-force`** - npm/pnpm/yarn → bun (strict replacement + devbox + RTK)
- **`devbox-rtk-nodejs-bun-block`** - block npm/pnpm/yarn (error + devbox + RTK)
- **`devbox-rtk-nodejs-bun-native`** - npm/pnpm/yarn as-is (devbox + RTK, no governance)

### Python Ecosystem

#### UV Governance
- **`devbox-rtk-python-uv-prefer`** - pip → uv (soft guidance + devbox + RTK)
- **`devbox-rtk-python-uv-force`** - pip → uv (strict replacement + devbox + RTK)
- **`devbox-rtk-python-uv-block`** - block pip (error + devbox + RTK)
- **`devbox-rtk-python-uv-native`** - pip as-is (devbox + RTK, no governance)

## How It Works

### Example: devbox-rtk-nodejs-pnpm-force

```bash
# User runs: npm install
# Integrated flow:
# 1. Governance: npm → pnpm (force replacement)
# 2. Environment: ensure pnpm via devbox
# 3. Optimization: pnpm → rtk pnpm
# 4. Final: devbox run -- rtk pnpm install
```

### Recursion Prevention

The integrated system prevents infinite recursion through multiple mechanisms:

1. **Environment Detection**: Checks for devbox environment variables
2. **Command Detection**: Detects if called via `devbox run --`
3. **Progress Markers**: Uses `DEVBOX_AUTO_IN_PROGRESS` and `RTK_WRAPPER_IN_PROGRESS`
4. **Package Availability**: Skips wrapping if tool already available

## Installation

### Nix (Flakes)
```bash
# Install integrated package
nix profile install .#devbox-rtk-nodejs-pnpm-force

# Use in devbox.json
{
  "packages": [
    "github:levonk/levonk-packages#devbox-rtk-nodejs-pnpm-force"
  ]
}
```

## Usage Examples

### Force pnpm
```bash
# Install: devbox-rtk-nodejs-pnpm-force
npm install
→ ✅ Using pnpm instead of npm (forced by policy)...
→ 📦 Adding pnpm to devbox environment...
→ devbox run -- rtk pnpm install
```

### Prefer pnpm
```bash
# Install: devbox-rtk-nodejs-pnpm-prefer
npm install
→ ⚠️ Prefer pnpm over npm. Using pnpm...
→ 📦 Adding pnpm to devbox environment...
→ devbox run -- rtk pnpm install
```

### Block npm
```bash
# Install: devbox-rtk-nodejs-pnpm-block
npm install
→ ❌ npm is blocked by policy. Use pnpm instead.
→ 💡 Install pnpm: https://pnpm.io/installation
→ exit 1
```

### Native (no governance)
```bash
# Install: devbox-rtk-nodejs-pnpm-native
npm install
→ 📦 Adding npm to devbox environment...
→ devbox run -- rtk npm install
```

## Adding New Integrated Packages

Currently, integrated packages are created manually following these steps:

1. **Create wrapper script** in this directory:
   ```bash
   # Format: {ecosystem}-{preferred-tool}-{governance}.sh
   # Example: rust-cargo-force.sh
   ```

2. **Follow the integrated pattern**:
   ```bash
   #!/usr/bin/env sh
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   . "$SCRIPT_DIR/utils/devbox-manager.sh"
   . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
   
   # Governance logic
   case "$(basename "$0")" in
       old-tool) echo "Using new tool..."; set -- new-tool "$@" ;;
   esac
   
   # Environment + RTK
   devbox_wrap new-tool "$@"
   ```

3. **Create Nix derivation** in `../../nix/`:
   ```nix
   { pkgs }:
   let
     old-wrapper = pkgs.writeShellScriptBin "old" ''
       ${builtins.readFile ../wrappers/devbox-rtk-tools/package.sh}
     '';
     new-wrapper = pkgs.writeShellScriptBin "new" ''
       # Environment + RTK logic
     '';
   in
   pkgs.symlinkJoin {
     name = "devbox-rtk-ecosystem-tool-governance";
     paths = [ old-wrapper new-wrapper ];
   }
   ```

4. **Update flake.nix** with imports and packages

5. **Update documentation** in AGENTS.md

## Benefits

- **No Conflicts**: Single package handles all concerns
- **Clear Intent**: Package name shows governance type
- **Complete Solution**: Environment + preference + optimization
- **Predictable**: Consistent behavior across tools
- **AI Agent Friendly**: Clear, automated behavior
- **Extensible**: Easy to add new ecosystems and tools

## Governance Types

- **prefer**: Soft guidance with warnings, routes to preferred tool
- **force**: Strict replacement, silent routing to preferred tool
- **block**: Complete prohibition, error when disfavored tool used
- **native**: No governance, tools used as-is with environment + RTK

## Ecosystem Support

Currently supported:
- **Node.js**: npm, pnpm, yarn, bun
- **Python**: pip, uv

Future ecosystems can be added following the same pattern.