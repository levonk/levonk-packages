# Devbox Auto-Wrapper Packages

This directory contains wrapper scripts that automatically ensure development tools are available via devbox by managing devbox.json and running commands through `devbox run --` when needed.

## Purpose

When AI agents or developers run standard commands like `npm`, `python`, or `cargo`, these wrappers automatically:
1. Check if the tool is available in the current environment
2. If not, find the nearest devbox.json
3. Add the tool to devbox.json if missing
4. Run the command via `devbox run --`
5. Prevent infinite recursion with multiple safety mechanisms

## How It Works

Each wrapper:
1. **Recursion Prevention**: Checks if already in devbox environment or called via `devbox run --`
2. **Package Availability**: Skips devbox if tool already available
3. **Auto-Discovery**: Finds devbox.json in current or parent directories
4. **Auto-Management**: Adds missing packages to devbox.json
5. **Graceful Fallback**: Falls back to native command if no devbox.json exists

## Available Wrappers

### Node.js Tools
- `npm` - Node package manager
- `pnpm` - Performant npm alternative
- `yarn` - Another Node package manager

### Python Tools
- `python` - Python interpreter
- `pip` - Python package installer

### Rust Tools
- `cargo` - Rust package manager
- `rustc` - Rust compiler

### Go Tools
- `go` - Go toolchain

## Recursion Prevention

The system prevents infinite recursion through multiple mechanisms:

### 1. Environment Detection
```bash
# Checks for devbox environment variables
[ -n "${DEVBOX_SHELL:-}" ] || [ -n "${IN_DEVBOX:-}" ] || [ -n "${DEVBOX_ENVIRONMENT:-}" ]
```

### 2. Command Detection
```bash
# Detects if called via "devbox run --"
is_devbox_run_command() {
    case "$1" in
        devbox|devbox.exe)
            shift
            [ "$1" = "run" ] && [ "$2" = "--" ]
            ;;
    esac
}
```

### 3. Progress Marker
```bash
# Uses environment variable to prevent double-wrapping
if [ -n "${DEVBOX_AUTO_IN_PROGRESS:-}" ]; then
    exec "$tool" "$@"  # Skip devbox, run directly
fi
export DEVBOX_AUTO_IN_PROGRESS=1
```

### 4. Package Availability
```bash
# Skips devbox if tool already available
if is_package_available "$tool"; then
    exec "$tool" "$@"  # Run directly
fi
```

## Installation

### Nix (Flakes)
```bash
# Install individual wrapper
nix profile install .#devbox-auto-npm

# Install bundle packages
nix profile install .#bundle-devbox-auto-all
```

### Devbox
Add to your `devbox.json`:
```json
{
  "packages": [
    "github:levonk/levonk-packages#bundle-devbox-auto-all"
  ]
}
```

## Usage Examples

### Normal Usage
```bash
# User runs: npm install
# Wrapper flow:
# 1. npm not available in current environment
# 2. Not in devbox environment
# 3. Found devbox.json in current directory
# 4. Added "npm" to devbox.json packages
# 5. Ran: devbox run -- npm install
```

### Already in Devbox
```bash
# User runs: npm install (inside devbox shell)
# Wrapper flow:
# 1. npm not available in current environment
# 2. DETECTED: In devbox environment (DEVBOX_SHELL set)
# 3. Ran: npm install directly (no devbox run --)
```

### Called via Devbox Run
```bash
# User runs: devbox run -- npm install
# Wrapper flow:
# 1. npm not available in current environment
# 2. DETECTED: Called via devbox run --
# 3. Ran: npm install directly (no recursion)
```

### Tool Already Available
```bash
# User runs: npm install (npm in PATH)
# Wrapper flow:
# 1. npm available in current environment
# 2. Ran: npm install directly (no devbox needed)
```

### No Devbox.json
```bash
# User runs: npm install (no devbox.json found)
# Wrapper flow:
# 1. npm not available in current environment
# 2. Not in devbox environment
# 3. No devbox.json found
# 4. Ran: npm install directly (fallback)
```

## Test Compatibility

The devbox-auto wrappers are designed to work with the existing devbox-based test framework:

- **Recursion Prevention**: Tests use `DEVBOX_AUTO_IN_PROGRESS=1` to test wrapper logic without triggering devbox
- **Environment Detection**: Tests run in devbox environments without infinite recursion
- **Fallback Behavior**: Tests verify graceful fallback when devbox.json doesn't exist

## Adding New Wrappers

1. Create wrapper script in this directory:
   ```bash
   #!/usr/bin/env sh
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
       . "$SCRIPT_DIR/utils/devbox-manager.sh"
   fi
   devbox_wrap <tool> "$@"
   ```

2. Create Nix derivation in `../../nix/devbox-auto-<tool>.nix`
3. Update `../../flake.nix` with new package
4. Add to appropriate bundle package
5. Run the automated generator: `./scripts/generate-devbox-auto-suite.sh`

## Benefits

- **Automatic Environment Setup**: No manual devbox.json management
- **Recursion Safe**: Multiple mechanisms prevent infinite loops
- **Test Compatible**: Works with existing devbox test framework
- **Graceful Fallback**: Works without devbox if needed
- **Transparent**: No changes needed to existing workflows
- **AI Agent Friendly**: Designed for automated agent environments