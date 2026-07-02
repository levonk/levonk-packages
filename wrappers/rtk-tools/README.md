# RTK Wrapper Packages

This directory contains wrapper scripts that transparently intercept common commands and run them through [RTK (Rust Token Killer)](https://github.com/rtk-ai/rtk) for token-optimized output.

## Purpose

When AI agents call standard commands like `ls`, `tree`, `git`, etc., these wrappers automatically route them through RTK to minimize token consumption without requiring the AI to know about RTK or change its behavior.

## How It Works

Each wrapper:
1. Checks if RTK is available on the system
2. If RTK is installed, runs the command through RTK (e.g., `rtk ls`)
3. If RTK is not installed, falls back to the native command with a warning
4. Uses a centralized utility script (`../utils/rtk-wrapper.sh`) for DRY implementation

## Available Wrappers

### Core Commands
- `ls` - Directory listing with token-optimized output
- `tree` - Directory tree with token-optimized output
- `cat` - File reading with intelligent filtering (via `rtk read`)
- `find` - File finding with compact tree output
- `grep` - Pattern matching with compact output
- `diff` - File differences with ultra-condensed output
- `wc` - Word/line/byte count with compact output

### Development Tools
- `git` - Git commands with compact output
- `npm` - Node package manager with filtered output
- `cargo` - Rust package manager with compact output
- `pip` - Python package manager with compact output

### Cloud & DevOps
- `gh` - GitHub CLI with token-optimized output
- `curl` - HTTP client with auto-JSON detection and schema output
- `docker` - Docker commands with compact output
- `kubectl` - Kubernetes commands with compact output

## Installation

### Nix (Flakes)
```bash
# Install individual wrapper
nix profile install .#rtk-wrap-ls

# Install bundle packages
nix profile install .#bundle-rtk-core      # Core commands
nix profile install .#bundle-rtk-development # Development tools
nix profile install .#bundle-rtk-cloud      # Cloud tools
nix profile install .#bundle-rtk-all        # All wrappers
```

### Devbox
Add to your `devbox.json`:
```json
{
  "packages": [
    "github:levonk/levonk-packages#bundle-rtk-all"
  ]
}
```

## Usage

Once installed, the wrappers work transparently. When you (or an AI agent) run:

```bash
ls -la
```

It automatically executes as:
```bash
rtk ls -la
```

If RTK is not installed, it falls back to:
```bash
ls -la
```

With a warning: `⚠️ RTK not found, using native ls. Install RTK for token-optimized output.`

## Adding New Wrappers

1. Create wrapper script in this directory
2. Use the centralized utility:
   ```bash
   #!/usr/bin/env sh
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
       . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
   fi
   rtk_wrap <native_cmd> <rtk_subcommand> "<description>"
   ```
3. Create corresponding Nix derivation in `../../nix/rtk-wrap-<cmd>.nix` using `../../nix/lib/rtk-wrap-lib.nix`
4. Update `../../flake.nix` with new package

## RTK Compatibility

These wrappers are designed to work with RTK commands that accept the same arguments as their native counterparts. For commands where RTK uses different semantics, adjust the wrapper accordingly.

## Benefits

- **Transparent**: No changes needed to AI agent behavior
- **Fallback**: Works even if RTK isn't installed
- **DRY**: Centralized utility reduces code duplication
- **Extensible**: Easy to add new command wrappers
- **Token Savings**: Automatically reduces LLM token consumption