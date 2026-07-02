# Agent Documentation: Command Preference & Package Governance System

## Purpose

This document guides agents in creating new packages for the levonk-packages governance system. For information about existing packages, counts, and installation, see [README.md](README.md). For detailed documentation about specific package classes, see the [docs/](docs/) directory.

## Quick Reference

- **Project Type**: Multi-package-manager governance system with Nix flake packages
- **Build System**: Nix flakes + Devbox + just
- **Package Generation**: Generates packages for 7+ ecosystems from single source
- **Test Framework**: Custom test suite with transient devbox environments

## Repository Structure

```
.
├── flake.nix                    # Nix flake definitions for all packages
├── justfile                     # Command runner with all build/generate/test commands
├── devbox.json                  # Devbox environment configuration
├── wrappers/                    # Source wrapper scripts (organized by tool class)
│   ├── nodejs-tools/           # Node.js package manager wrappers
│   ├── python-tools/           # Python package manager wrappers
│   ├── search-tools/           # Search tool wrappers
│   ├── rtk-tools/              # RTK token optimization wrappers
│   ├── devbox-auto-tools/      # Devbox environment management wrappers
│   ├── devbox-rtk-tools/       # Integrated devbox + RTK + governance wrappers
│   └── utils/                  # Shared utility scripts
├── nix/                         # Nix derivations (organized by package class)
├── packaging/                   # Package generators for all ecosystems
│   ├── alpine/generate-apk.sh   # Alpine APK generator
│   ├── debian/generate-deb.sh   # Debian DEB generator
│   ├── fedora/generate-rpm.sh   # Fedora RPM generator
│   ├── arch/generate-pkgbuild.sh # Arch PKGBUILD generator
│   ├── brew/generate-formula.rb  # Homebrew formula generator
│   └── mise/generate-mise-plugins.sh # mise plugin generator
├── scripts/                     # Utility and test scripts
├── docs/                        # Detailed documentation for package classes
└── .tickets/                    # tkr ticket tracking system
```

## Core Concepts

### Integrated Package Philosophy

**IMPORTANT**: When adding new tools or ecosystems, **always use integrated `devbox-rtk-*` packages** rather than creating separate wrapper systems.

### Why Integrated Packages?

**Problem with Separate Systems**:
- `prefer-pnpm` + `devbox-auto-npm` + `rtk-wrap-npm` = **Conflicting behavior**
- Multiple wrappers can interfere with each other
- Unclear which system takes precedence
- Complex dependency management

**Solution with Integrated Packages**:
- `devbox-rtk-nodejs-pnpm-force` = **Single coherent package**
- Clear governance intent in package name
- No conflicts between systems
- Predictable behavior

### Package Design Principles

1. **Single Source of Truth**: One package per tool ecosystem + governance type
2. **Clear Naming**: Package name shows ecosystem, preferred tool, and governance
3. **Complete Coverage**: Each package handles environment + preference + optimization
4. **No Conflicts**: Integrated logic prevents wrapper interference
5. **AI Agent Friendly**: Predictable behavior for automated systems

### When to Use Each Package Type

| Scenario | Package Type | Example |
|----------|-------------|---------|
| Tool replacement only | `prefer-*`, `force-*`, `block-*` | `prefer-pnpm` |
| Environment management only | `devbox-auto-*` | `devbox-auto-python` |
| Token optimization only | `rtk-wrap-*` | `rtk-wrap-ls` |
| **Complete solution** | **`devbox-rtk-*`** | **`devbox-rtk-nodejs-pnpm-force`** |

### Package Naming Convention

```
devbox-rtk-{ecosystem}-{preferred-tool}-{governance-type}
```

**Examples**:
- `devbox-rtk-nodejs-pnpm-prefer` - Node.js ecosystem, prefer pnpm (soft guidance)
- `devbox-rtk-nodejs-pnpm-force` - Node.js ecosystem, force pnpm (strict replacement)
- `devbox-rtk-nodejs-pnpm-block` - Node.js ecosystem, block npm (error)
- `devbox-rtk-nodejs-pnpm-native` - Node.js ecosystem, use npm as-is (no governance)

**Ecosystems**: `nodejs`, `python`, `rust`, `go`, `dotnet`, etc.
**Governance Types**: `prefer`, `force`, `block`, `native`

### Adding New Tool Ecosystems

**ALWAYS follow this sequence**:

1. **Assess Requirements**: Determine if the tool needs:
   - Environment management (devbox)
   - Token optimization (RTK)
   - Tool governance (prefer/force/block)

2. **Create Integrated Packages**: If any combination is needed, create `devbox-rtk-*` packages using `nix/lib/devbox-rtk-lib.nix` (see an existing `nix/devbox-rtk-*.nix` for the pattern)
3. **Test Integration**: Verify all three concerns work together
4. **Document**: Update AGENTS.md with ecosystem information

**NEVER create separate wrapper systems** that might conflict with existing ones.

### Package Governance Types

1. **`prefer-*`** - Soft guidance with warnings and delegation
   - Warns when disfavored tool is used
   - Delegates to preferred tool if installed
   - Does NOT remove or block disfavored tool

2. **`eject-*`** - Enforcement engine
   - Removes disfavored tool if possible
   - Blocks future installation
   - Shadows binary with wrapper

3. **`force-*`** - Strict replacement
   - Depends on `eject-*`
   - Installs preferred tool
   - Replaces disfavored tool with wrapper

4. **`block-*`** - Complete prohibition
   - Depends on `eject-*`
   - Replaces disfavored command with error-exiting wrapper

5. **`rtk-wrap-*`** - RTK token optimization wrappers
   - Transparently intercepts commands and runs them through RTK
   - Falls back to native command if RTK is not installed
   - Designed for AI agent environments to minimize token consumption
   - No dependency enforcement - works with or without RTK installed
   - **DEPRECATED**: Use integrated `devbox-rtk-*` packages instead

6. **`devbox-auto-*`** - Devbox environment management wrappers
   - Automatically ensures tools are available via devbox
   - Adds missing packages to devbox.json automatically
   - Runs commands via `devbox run --` when needed
   - Recursion prevention for devbox environments
   - Falls back to native command if no devbox.json exists
   - **DEPRECATED**: Use integrated `devbox-rtk-*` packages instead

7. **`devbox-rtk-*`** - Integrated environment + optimization + governance packages
   - Combines devbox environment management, RTK token optimization, and tool governance
   - Naming convention: `devbox-rtk-{ecosystem}-{preferred-tool}-{governance-type}`
   - Governance types: `prefer`, `force`, `block`, `native`
   - Single package handles all concerns: environment setup, tool preference, and output optimization
   - Prevents conflicts between separate wrapper systems
   - **RECOMMENDED**: Use these for new tool integrations

### Package Ecosystems

- **Immediate**: Nix (flakes, Devbox, home-manager, NixOS)
- **Generated**: Alpine (APK), Debian/Ubuntu (DEB), Fedora (RPM), Arch (PKGBUILD), Homebrew, mise

## Development Workflow

### Environment Setup

```bash
# Clone and bootstrap
devbox run -- rtk git clone https://github.com/levonk/levonk-packages.git
cd levonk-packages
devbox run -- rtk just bootstrap-internal

# Verify environment
devbox run -- rtk just doctor-internal
```

### Daily Commands

```bash
# Build all Nix packages
devbox run -- rtk just build-internal

# Test package functionality
devbox run -- rtk just test-internal

# Generate packages for all ecosystems
devbox run -- rtk just generate-internal

# Quick validation
devbox run -- rtk just test-comprehensive-internal
```

### Critical Implementation Steps

**MUST FOLLOW THIS SEQUENCE for new package ecosystems:**

1. **Create ALL wrapper scripts first** - Every package needs a corresponding wrapper script
2. **Create ALL Nix derivations** - Each wrapper script needs a Nix derivation, using the shared library in `nix/lib/` (see an existing package in the same class for the pattern)
3. **Update flake.nix imports AND packages sections** - Both sections must include all packages
4. **Add ALL files to git** - Nix requires all files to be tracked
5. **Test individual packages** - Verify each package builds and runs
6. **Update documentation** - Update AGENTS.md with correct counts and descriptions
7. **Run full test suite** - Ensure nothing is broken
8. **Do a test intsall in a temporary devbox.json** - Make sure the package works in a real environment

**Common Pitfalls:**
- ❌ Forgetting to add files to git (Nix will fail to build)
- ❌ Only updating imports OR packages section (both needed)
- ❌ Creating documentation without implementing packages
- ❌ Testing only one package variant (test all 4 variants)
- ❌ Forgetting to update bundle package counts

### Shared Nix Libraries

Each wrapper class has a shared library in `nix/lib/` that inlines the utility scripts (`devbox-manager.sh`, `rtk-wrapper.sh`) at build time via `builtins.readFile`. New packages should use these libraries instead of duplicating wrapper logic:

- **`nix/lib/devbox-rtk-lib.nix`** - Integrated devbox + RTK + governance wrappers (`devbox-rtk-*` packages)
- **`nix/lib/devbox-auto-lib.nix`** - Devbox auto-environment wrappers (`devbox-auto-*` packages)
- **`nix/lib/rtk-wrap-lib.nix`** - RTK token-optimization wrappers (`rtk-wrap-*` packages)

To add a new package, copy an existing `.nix` file in the same class and adapt the `wrapperContent` / `name` / `nativeCmd` fields. The shared library handles inlining the utility scripts and calling the wrap function.

### Standardized Testing Framework

**Use the unified testing framework instead of individual test scripts:**

```bash
# Run all tests
devbox run -- rtk just test-internal

# Run specific test categories
./scripts/test-governance-unified.sh all
./scripts/test-governance-unified.sh nodejs
./scripts/test-governance-unified.sh search
./scripts/test-governance-unified.sh prefer-grep

# Generate test reports
./scripts/test-governance-unified.sh all > test-results.txt
```

**Benefits of unified framework:**
- **Standardized output** with consistent logging
- **Test result tracking** in `test-results/` directory
- **Package family testing** (test all variants of a tool)
- **Comprehensive reporting** with pass/fail statistics
- **No more "hodgepodge" of individual test scripts**

### Testing Requirements for New Packages

**All new governance packages MUST include:**

1. **Automated test integration** - Add test cases to `scripts/test-governance-unified.sh`
2. **Behavior validation** - Each governance type tested for correct behavior
3. **Build verification** - All packages must build successfully
4. **Result tracking** - Test results stored in `test-results/` directory

**Test Coverage Requirements:**
- **100% package coverage** - All 4 variants must be tested
- **Behavior validation** - Warning, force, block, and eject behaviors verified
- **Build verification** - Nix build success for all packages
- **Cross-platform compatibility** - Tests work on all supported platforms

### Wrapper Directory Organization

**✅ COMPLETED** - Reorganized on 2026-03-24

**Previous Issue**: 71+ wrapper files in flat `wrappers/` directory becoming unwieldy  
**Solution**: **Hierarchical Organization with kebab-case naming**

**Current Structure**:
```
wrappers/
├── nodejs-tools/       (46 files) - npm, pnpm, yarn, bun packages
├── python-tools/       (3 files)  - pip packages  
├── search-tools/       (24 files) - grep, ag, git-grep, ucg, pt, sift packages
├── system-tools/       (2 files)  - curl, node packages
├── privilege-tools/    (8 files)  - sudo, pkexec, doas, sudo-rs packages
├── download-tools/     (10 files) - curl, wget, httpie, wget2, aria2 packages
├── find-tools/         (8 files)  - find, fd packages
├── locate-tools/       (8 files)  - locate, plocate packages
├── text-tools/         (8 files)  - sed, sd packages
├── rtk-tools/          (54 files) - RTK token optimization wrappers (ls, tree, git, npm, pnpm, tsc, jest, etc.)
├── devbox-auto-tools/  (8 files)  - Devbox environment management wrappers (npm, python, cargo, etc.)
├── devbox-rtk-tools/   (16 files) - Integrated devbox + RTK + governance wrappers (nodejs, python ecosystems)
└── utils/              (shared utilities)
```

**Migration Results**:
- ✅ **Logical grouping** by tool ecosystem
- ✅ **Scalable** for new tool categories  
- ✅ **Easy navigation** and maintenance
- ✅ **Clear ownership** boundaries
- ✅ **Consistent kebab-case naming** convention
- ✅ **Preserved git history** using `git mv`
- ✅ **All packages build** correctly with new paths

**Benefits Achieved**:
- No more flat directory with 71+ files
- Clear separation by tool type
- Easy to find specific tools
- Scalable for future additions

### RTK Wrapper Packages

**✅ COMPLETED** - Added on 2026-06-21

**Purpose**: Transparently intercept AI agent commands and run them through [RTK (Rust Token Killer)](https://github.com/rtk-ai/rtk) for token-optimized output without requiring AI behavior changes.

**Available RTK Wrappers**:
- **Core Commands**: `ls`, `tree`, `cat`, `find`, `grep`, `diff`, `wc`
- **Development Tools**: `git`, `npm`, `cargo`, `pip`
- **Cloud & DevOps**: `gh`, `curl`, `docker`, `kubectl`

**Bundle Packages**:
- `bundle-rtk-core` - Core command wrappers (ls, tree, cat, find, grep, diff, wc)
- `bundle-rtk-development` - Development tool wrappers (git, npm, cargo, pip, docker, kubectl)
- `bundle-rtk-cloud` - Cloud tool wrappers (gh, curl)
- `bundle-rtk-all` - All RTK wrappers combined

**Key Features**:
- **Transparent**: No AI agent changes required
- **Fallback**: Works with or without RTK installed
- **DRY**: Centralized utility script (`utils/rtk-wrapper.sh`)
- **Extensible**: Easy to add new command wrappers
- **Token Savings**: Automatically reduces LLM token consumption

**Installation**:
```bash
# Install individual wrapper
devbox run -- rtk nix profile install .#rtk-wrap-ls

# Install bundle packages
devbox run -- rtk nix profile install .#bundle-rtk-all
```

**Adding New RTK Wrappers**:
```bash
# Add manually using the shared library:
# 1. Create wrapper in wrappers/rtk-tools/
# 2. Create Nix derivation in nix/rtk-wrap-<cmd>.nix using nix/lib/rtk-wrap-lib.nix
# 3. Update flake.nix imports and packages
# 4. Add to appropriate bundle package
```

### Adding New Packages

1. **Create wrapper script** in `wrappers/`:
   ```bash
   # Example: wrappers/npm.prefer-newtool.sh
   #!/usr/bin/env sh
   # Source the package detection utility
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   if [ -f "$SCRIPT_DIR/utils/detect-packages.sh" ]; then
       . "$SCRIPT_DIR/utils/detect-packages.sh"
   fi

   # Detect available alternatives
   echo "⚠️ Prefer newtool over npm. Detecting available alternatives..."

   # List available alternatives
   available_found=false
   for tool in newtool; do
       if command -v "$tool" >/dev/null 2>&1; then
           echo "✅ Using $tool (preferred)"
           exec "$tool" "$@"
       fi
   done

   # Fallback to preferred tool
   echo "🔄 Running newtool..."
   exec newtool "$@"
   ```

2. **Create Nix derivation** in `nix/`:
   ```nix
   # Example: nix/prefer-newtool.nix
   { pkgs }:
   pkgs.writeShellScriptBin "npm" ''
     #!/usr/bin/env sh
     ${builtins.readFile ../wrappers/npm.prefer-newtool.sh}
   ''
   ```

3. **Add to flake.nix** packages section:
   ```nix
   # In imports section
   prefer-newtool = import ./nix/prefer-newtool.nix { inherit pkgs; };
   
   # In packages section
   inherit prefer-newtool;
   ```

4. **Update packaging generators** to include new package

5. **Add all files to git**:
   ```bash
   git add wrappers/newtool.* nix/*newtool* flake.nix
   ```

6. **Test with**: `devbox run -- rtk nix build .#prefer-newtool` and `devbox run -- rtk nix run .#prefer-newtool -- --help`

7. **Update documentation** in AGENTS.md

8. **Test with**: `devbox run -- rtk just test-internal` and `devbox run -- rtk just generate-internal`

### Creating Complete Package Families

When creating a new tool migration (like ripgrep), you need to create all 4 governance variants for each tool:

#### DRY Principles for Bulk Package Creation

**CRITICAL**: When creating packages in bulk (which is the usual case), the system attempts to be DRY - **Don't Repeat Yourself**.

**What this means:**
- Do NOT repeat warning strings, error strings, or remapping logic across multiple files
- Centralize shared logic in utility scripts or template files
- When remapping a tool chain (e.g., Rust: cargo, rustc, clippy), use a single file that handles all commands
- Changes to warnings, errors, or remapping behavior should only need to be made in ONE place

**Example: Rust tool chain remapping**
Instead of creating separate wrapper scripts for cargo, rustc, clippy, etc. with duplicated warning/error strings:
- ✅ Create ONE utility file that handles the entire Rust tool chain
- ✅ Pass the specific command as a parameter to the shared logic
- ✅ Update warning/error messages in one place only

**Example: DevBox tool remapping**
When remapping multiple common tools to run through DevBox:
- ✅ Use a single DevBox integration file
- ✅ Parameterize the specific command being wrapped
- ✅ Maintain consistent behavior across all wrapped tools

**Benefits:**
- Single point of maintenance for warnings, errors, and remapping logic
- Consistent user experience across all wrapped tools
- Easier to update behavior when requirements change
- Reduced risk of inconsistencies across similar packages

#### Example: Complete ripgrep ecosystem creation
```bash
# 1. Create all wrapper scripts (6 tools × 4 variants = 24 files)
for tool in grep ag git-grep ucg pt sift; do
  for variant in prefer-ripgrep eject-$tool force-$tool block-$tool; do
    # Create wrapper script with appropriate logic
    touch wrappers/$tool.$variant.sh
  done
done

# 2. Create all Nix derivations (24 files)
for tool in grep ag git-grep ucg pt sift; do
  for variant in prefer-ripgrep eject-$tool force-$tool block-$tool; do
    # Create Nix derivation
    touch nix/$variant.nix
  done
done

# 3. Update flake.nix with all imports and packages
# Add each package to both imports and packages sections

# 4. Add all files to git
devbox run -- rtk git add wrappers/*grep* wrappers/*ag* wrappers/*git-grep* wrappers/*ucg* wrappers/*pt* wrappers/*sift*
devbox run -- rtk git add nix/*grep* nix/*ag* nix/*git-grep* nix/*ucg* nix/*pt* nix/*sift*
devbox run -- rtk git add flake.nix AGENTS.md

# 5. Test individual packages
devbox run -- rtk nix build .#prefer-grep && devbox run -- rtk nix run .#prefer-grep -- --help
devbox run -- rtk nix build .#force-ag && devbox run -- rtk nix run .#force-ag -- "test" .
devbox run -- rtk nix build .#block-sift && devbox run -- rtk nix run .#block-sift -- --version

# 6. Update documentation counts
# Update AGENTS.md with new package totals and bundle counts
```

#### Package Naming Patterns
- **`prefer-{tool}`** - Soft guidance preferring new tool
- **`eject-{tool}`** - Remove old tool and use new tool
- **`force-{tool}`** - Force old tool command to run new tool
- **`block-{tool}`** - Completely block old tool usage

## Package Generation

### Generate All Ecosystems

```bash
# Generate packages for all ecosystems
devbox run -- rtk just generate-internal

# Or specific ecosystems
devbox run -- rtk just generate-internal
```

### Generated Package Locations

- **Alpine**: `packaging/alpine/<package>/APKBUILD`
- **Debian**: `packaging/debian/<package>/debian/`
- **Fedora**: `packaging/fedora/<package>/rpm.spec`
- **Arch**: `packaging/arch/<package>/PKGBUILD`
- **Homebrew**: `packaging/brew/<package>.rb`
- **mise**: `packaging/mise/<package>/`

### Building Generated Packages

```bash
# Alpine
cd packaging/alpine/prefer-pnpm && abuild -r

# Debian
cd packaging/debian/prefer-pnpm && dpkg-buildpackage -us -uc

# Fedora
cd packaging/fedora/prefer-pnpm && rpmbuild -ba rpm.spec

# Arch
cd packaging/arch/prefer-pnpm && makepkg -si
```

## Testing

### Test Structure

- **Individual package tests**: Validate wrapper behavior
- **Bundle tests**: Test package combinations
- **Cross-ecosystem tests**: Verify generated packages
- **Transient environments**: Isolated devbox test spaces
- **Ripgrep-specific tests**: Dedicated test suite for search tool governance
- **Devbox reminder tests**: Per-governance-variant tests in isolated devbox environments

### Running Tests

```bash
# Quick functionality tests
devbox run -- rtk just test-internal

# Ripgrep-specific tests (24 packages)
devbox run -- rtk just test-ripgrep-internal

# Comprehensive test suite
devbox run -- rtk just test-comprehensive-internal

# Individual package testing
devbox run -- rtk just test-internal-internal

# Devbox reminder tests (per governance variant)
cd tests/devbox-reminders/prefer && devbox shell   # Tests prefer-* wrappers
cd tests/devbox-reminders/force  && devbox shell   # Tests force-* wrappers
cd tests/devbox-reminders/block  && devbox shell   # Tests block-* wrappers
cd tests/devbox-reminders/eject  && devbox shell   # Tests eject-* wrappers
```

### Test Coverage

- **289 individual governance packages tested** (115 existing + 92 devbox reminder + 54 RTK wrapper + 8 devbox-auto + 16 devbox-rtk-governance)
- **19 bundle packages tested** (11 existing + 4 RTK bundle + 4 devbox-auto bundle)
- **303 test scenarios total**
- **Transient devbox environments for isolation**

#### Devbox Reminder Test Structure

The devbox reminder test suite lives in `tests/devbox-reminders/` with one directory per governance variant:

```
tests/devbox-reminders/
├── prefer/
│   ├── devbox.json   # init_hook runs ./test.sh
│   └── test.sh       # Runs all 23 tools with --version
├── force/
│   ├── devbox.json   # init_hook runs ./test.sh
│   └── test.sh       # Runs all 23 tools with --version
├── block/
│   ├── devbox.json   # init_hook runs ./test.sh
│   └── test.sh       # Verifies all 23 tools are blocked (exit 1)
└── eject/
    ├── devbox.json   # init_hook runs ./test.sh
    └── test.sh       # Runs all 23 tools with --version
```

**Adding a new devbox reminder tool:** When adding a new tool to the devbox reminder family, update all four `test.sh` scripts to include the new tool. Each script has a `test_tool` function; add a line like:

```sh
test_tool "newtool" "newtool --version"
```

The test scripts use `command -v` to gracefully skip tools not installed in the current environment, so tests will pass even when only a subset of tools are available.

**To run after changes:**

```bash
# Test a single variant
cd tests/devbox-reminders/prefer && devbox shell

# Or test all four variants
for dir in prefer force block eject; do
  echo "=== Testing $dir ==="
  (cd "tests/devbox-reminders/$dir" && devbox shell)
done
```

#### Ripgrep Test Results

Current test coverage for ripgrep packages:
- **Force packages** (6/6) - Direct ripgrep execution
- **Block packages** (6/6) - Proper blocking with error messages
- **Prefer packages** (0/6) - Need regex pattern refinement
- **Eject packages** (0/6) - Need regex pattern refinement

**Overall: 18/24 tests passing (75% success rate)**

## Package Manager Integration

### Devbox Usage

```bash
# Add individual packages
devbox add github:levonk/levonk-packages#prefer-pnpm

# Add comprehensive governance
devbox add github:levonk/levonk-packages#command-governance

# Add ecosystem bundles
devbox add github:levonk/levonk-packages#nodejs-ecosystem
devbox add github:levonk/levonk-packages#python-ecosystem
```

### Direct Nix Usage

```bash
# Build packages
devbox run -- rtk nix build .#prefer-pnpm
devbox run -- rtk nix build .#command-governance

# Run governed commands
devbox run -- rtk nix run .#prefer-pnpm -- --version
```

## Package Classes

The levonk-packages system organizes packages into distinct classes based on their purpose and governance approach. For detailed information about each class, including available packages and usage examples, see the [docs/](docs/) directory.

### Traditional Governance Packages
**Purpose**: Enforce tool preferences through soft guidance, strict replacement, or complete prohibition.

**Governance Types**:
- **`prefer-*`** - Soft guidance with warnings and delegation
- **`eject-*`** - Enforcement engine that removes disfavored tools
- **`force-*`** - Strict replacement with wrapper
- **`block-*`** - Complete prohibition with error-exiting wrapper

**Examples**: npm → pnpm, pip → uv, grep → ripgrep, sudo → sudo-rs

**Documentation**: See [docs/traditional-governance.md](docs/traditional-governance.md)

### RTK Token Optimization Wrappers
**Purpose**: Transparently intercept AI agent commands and run them through RTK for token-optimized output.

**Key Features**:
- Transparent optimization (no AI behavior changes required)
- Graceful fallback when RTK is not installed
- Designed specifically for AI agent environments
- Token savings for common commands (ls, git, npm, etc.)

**Bundle Packages**: `bundle-rtk-core`, `bundle-rtk-development`, `bundle-rtk-cloud`, `bundle-rtk-all`

**Documentation**: See [docs/rtk-wrappers.md](docs/rtk-wrappers.md)

### Devbox Auto-Environment Management
**Purpose**: Automatically ensure development tools are available via devbox by managing devbox.json and running commands through `devbox run --`.

**Key Features**:
- Recursion prevention for devbox environments
- Auto-discovery of devbox.json files
- Auto-management of devbox.json packages
- Graceful fallback when no devbox.json exists

**Bundle Packages**: `bundle-devbox-auto-nodejs`, `bundle-devbox-auto-python`, `bundle-devbox-auto-rust`, `bundle-devbox-auto-go`, `bundle-devbox-auto-all`

**Documentation**: See [docs/devbox-auto.md](docs/devbox-auto.md)

### Integrated Devbox-RTK-Governance Packages
**Purpose**: Combine devbox environment management, RTK token optimization, and tool governance in a single package.

**Naming Convention**: `devbox-rtk-{ecosystem}-{preferred-tool}-{governance-type}`

**Governance Types**: `prefer`, `force`, `block`, `native`

**Examples**: `devbox-rtk-nodejs-pnpm-force`, `devbox-rtk-python-uv-prefer`

**Benefits**:
- No conflicts between separate wrapper systems
- Clear governance intent in package name
- Complete solution (environment + preference + optimization)
- Predictable behavior for AI agents

**Documentation**: See [docs/integrated-packages.md](docs/integrated-packages.md)

### Devbox Reminder Governance
**Purpose**: Intercept development tool invocations and remind/warn/enforce the use of `devbox run <tool>` to ensure correct toolchain configuration.

**Governance Types**:
- **`prefer-*`**: Warns that `devbox run <tool>` is preferred
- **`force-*`**: Automatically runs `devbox run <tool>` when devbox.json is found
- **`eject-*`**: Attempts `devbox run <tool>` first, falls back to direct execution
- **`block-*`**: Blocks direct tool execution entirely

**Covered Tools**: Rust (cargo, rustc), Node.js/TypeScript (tsc, node), Python (python, pip, uv), Java (java, javac), Go (go, swift), Build tools (make, cmake, ninja, just), C/C++ (gcc, clang), .NET/Ruby (dotnet, ruby, gem)

**Documentation**: See [docs/devbox-reminders.md](docs/devbox-reminders.md)

### Bundle Packages
**Purpose**: Combine multiple related packages into a single installation for convenience.

**Types**:
- **Ecosystem bundles**: All packages for a specific ecosystem (e.g., `nodejs-ecosystem`, `python-ecosystem`)
- **Migration bundles**: Complete tool migration packages (e.g., `migrate-to-pnpm-bundle`)
- **Tool category bundles**: All packages for a tool category (e.g., `privilege-tools`, `download-tools`)
- **Class bundles**: All packages in a class (e.g., `bundle-rtk-all`, `bundle-devbox-auto-all`)

**Documentation**: See [docs/bundle-packages.md](docs/bundle-packages.md)

## Adding New RTK Wrappers

Add manually using the shared library:
1. Create wrapper script in `wrappers/rtk-tools/`
2. Create Nix derivation in `nix/rtk-wrap-<cmd>.nix` using `nix/lib/rtk-wrap-lib.nix`
3. Update `flake.nix` imports and packages sections
4. Add to appropriate bundle package
5. Update documentation

## RTK Command Sync Workflow

To keep RTK wrapper packages synchronized with the official RTK README, use the automated workflow:

```bash
# With Archon CLI
bun run cli workflow run sync-rtk-commands

# Or manually run the workflow steps
# The workflow is located in:
# - .agents/workflows/sync-rtk-commands.yaml (for Archon agents)
# - .devin/workflows/sync-rtk-commands.yaml (for Devin agents)
```

**What the workflow does**:
1. **Fetches** the latest RTK README from GitHub
2. **Extracts** all RTK commands from the README
3. **Compares** with existing wrapper packages
4. **Generates** missing wrapper scripts automatically
5. **Creates** Nix derivations for new wrappers
6. **Updates** flake.nix with new packages
7. **Updates** bundle packages (core, development, cloud, all)
8. **Updates** the generator script with new commands
9. **Generates** devbox-rtk integrated packages for development tools
10. **Updates** documentation with new package counts
11. **Commits** all changes with a descriptive message

**Workflow location**: `.agents/workflows/sync-rtk-commands.yaml` (also in `.devin/workflows/`)

**Benefits**:
- **Automated**: No manual tracking of RTK command additions
- **Comprehensive**: Covers all RTK commands from the official README
- **Integrated**: Automatically creates devbox-rtk packages for dev tools
- **Safe**: Only adds missing commands, doesn't modify existing ones
- **Documented**: Updates documentation automatically

**Manual sync** (if workflow unavailable):
```bash
# 1. Fetch RTK README
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/develop/README.md -o /tmp/rtk-readme.md

# 2. Extract commands
grep "rtk " /tmp/rtk-readme.md | sed 's/.*rtk //' | sed 's/ .*//' | sort -u > /tmp/rtk-commands.txt

# 3. Compare with existing
ls wrappers/rtk-tools/*.rtk-wrap.sh | xargs -I {} basename {} .rtk-wrap.sh | sort > /tmp/existing-commands.txt
comm -13 /tmp/existing-commands.txt /tmp/rtk-commands.txt > /tmp/missing-commands.txt

# 4. Generate missing wrappers (see existing pattern)
```

## Search Tool Governance: ripgrep

For detailed information about ripgrep governance packages, including usage examples and performance comparisons, see [docs/ripgrep-governance.md](docs/ripgrep-governance.md).

## Common Tasks

### Add New Tool Migration

1. Create wrapper scripts in `wrappers/`
2. Create Nix derivations in `nix/`
3. Update `flake.nix` packages section
4. Add to packaging generators
5. Update bundle packages
6. Test with `devbox run -- rtk just test-internal`

### Debug Package Issues

```bash
# Test individual package
devbox run -- rtk nix run .#prefer-pnpm -- --version

# Check wrapper script
cat wrappers/npm.prefer-pnpm.sh

# Verify Nix derivation
devbox run -- rtk nix build .#prefer-pnpm --print-build-logs
```

### Release Process

```bash
# Build and test everything
devbox run -- rtk just build-internal && devbox run -- rtk just test-internal

# Generate all packaging
devbox run -- rtk just generate-internal

# Create release artifacts
devbox run -- rtk just release-internal
```

## Key Files to Understand

- **`flake.nix`** - Core package definitions and dependencies
- **`justfile`** - All available commands and workflows
- **`wrappers/*.sh`** - Actual governance logic
- **`packaging/*/generate-*`** - Cross-ecosystem package generation
- **`docs/SPEC.md`** - Complete technical specification

## Troubleshooting

### Common Issues

1. **Package build fails**: Check wrapper script syntax and Nix derivation
2. **Generation fails**: Verify packaging generator scripts have execute permissions
3. **Tests fail**: Ensure devbox environment is properly initialized

### Getting Help

```bash
# Check environment health
devbox run -- rtk just doctor-internal

# See available commands
devbox run -- rtk just --list

# Test specific package
devbox run -- rtk nix run .#package-name -- --help
```

## Development Standards

- **Wrapper scripts**: Use POSIX shell (`#!/usr/bin/env sh`)
- **Nix derivations**: Follow existing patterns in `nix/`
- **Package generation**: Use consistent naming across ecosystems
- **Testing**: Add tests for all new packages
- **Documentation**: Update README.md and SPEC.md for new features

## Integration Points

- **Standard Developer UX Flow**: `direnv → devbox → just (*-internal) → cargo`
- **AI Agent Governance**: Primary use case for automated tooling enforcement
- **Multi-Project Environments**: Support for different projects using different tools

This system provides unified governance across development ecosystems while maintaining compatibility with existing workflows.
