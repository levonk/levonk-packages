# Agent Documentation: Command Preference & Package Governance System

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
├── wrappers/                    # Source wrapper scripts (115 files)
│   ├── npm.prefer-pnpm.sh      # Example: npm → pnpm wrapper
│   ├── pip.prefer-uv.sh        # Example: pip → uv wrapper
│   └── utils/detect-packages.sh # Dynamic package detection
├── nix/                         # Nix derivations (115 files)
│   ├── prefer-pnpm.nix         # Individual package derivations
│   └── bundle-command-governance.nix # Bundle packages
├── packaging/                   # Package generators for all ecosystems
│   ├── alpine/generate-apk.sh   # Alpine APK generator
│   ├── debian/generate-deb.sh   # Debian DEB generator
│   ├── fedora/generate-rpm.sh   # Fedora RPM generator
│   ├── arch/generate-pkgbuild.sh # Arch PKGBUILD generator
│   ├── brew/generate-formula.rb  # Homebrew formula generator
│   └── mise/generate-mise-plugins.sh # mise plugin generator
├── scripts/                     # Utility and test scripts
├── docs/                        # Documentation and specs
└── .tickets/                    # tkr ticket tracking system
```

## Core Concepts

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
   - Replaces disfavored tool with error-exiting wrapper

### Package Ecosystems

- **Immediate**: Nix (flakes, Devbox, home-manager, NixOS)
- **Generated**: Alpine (APK), Debian/Ubuntu (DEB), Fedora (RPM), Arch (PKGBUILD), Homebrew, mise

## Development Workflow

### Environment Setup

```bash
# Clone and bootstrap
git clone https://github.com/levonk/levonk-packages.git
cd levonk-packages
just bootstrap

# Verify environment
just doctor
```

### Daily Commands

```bash
# Build all Nix packages
just build

# Test package functionality
just test

# Generate packages for all ecosystems
just generate

# Quick validation
just test-comprehensive
```

### Critical Implementation Steps

**MUST FOLLOW THIS SEQUENCE for new package ecosystems:**

1. **Use Automated Generation** - Use `scripts/generate-governance-suite.sh` for complete suites
2. **Create ALL wrapper scripts first** - Every package needs a corresponding wrapper script
3. **Create ALL Nix derivations** - Each wrapper script needs a Nix derivation
4. **Update flake.nix imports AND packages sections** - Both sections must include all packages
5. **Add ALL files to git** - Nix requires all files to be tracked
6. **Test individual packages** - Verify each package builds and runs
7. **Update documentation** - Update AGENTS.md with correct counts and descriptions
8. **Run full test suite** - Ensure nothing is broken

**Common Pitfalls:**
- ❌ Forgetting to add files to git (Nix will fail to build)
- ❌ Only updating imports OR packages section (both needed)
- ❌ Creating documentation without implementing packages
- ❌ Testing only one package variant (test all 4 variants)
- ❌ Forgetting to update bundle package counts
- ❌ Not using the automated generation system

### Automated Package Generation

For new tool ecosystems, use the automated generation system:

```bash
# Generate complete governance suite for a tool
./scripts/generate-governance-suite.sh <tool> [action]

# Examples:
./scripts/generate-governance-suite.sh curl suite      # Complete suite
./scripts/generate-governance-suite.sh curl ecosystem  # All ecosystem packages
./scripts/generate-governance-suite.sh curl docs       # Documentation only
./scripts/generate-governance-suite.sh curl all        # Everything

# Available tools: npm, pnpm, yarn, bun, pip, grep, ag, git-grep, ucg, pt, sift, sudo, curl, wget, find, locate, sed
```

**What the generator creates:**
- **4 wrapper scripts** per tool (prefer, eject, force, block)
- **4 Nix derivations** per tool
- **Updated flake.nix** with imports and packages
- **Test integration** with unified test framework
- **Git tracking** for all new files

### Standardized Testing Framework

**Use the unified testing framework instead of individual test scripts:**

```bash
# Run all tests
just test

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

1. **Automated test integration** - Generated by `generate-governance-suite.sh`
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
├── nodejs-tools/     (46 files) - npm, pnpm, yarn, bun packages
├── python-tools/     (3 files)  - pip packages  
├── search-tools/     (24 files) - grep, ag, git-grep, ucg, pt, sift packages
├── system-tools/     (2 files)  - curl, node packages
├── privilege-tools/  (8 files)  - sudo, pkexec, doas, sudo-rs packages
├── download-tools/   (10 files) - curl, wget, httpie, wget2, aria2 packages
├── find-tools/       (8 files)  - find, fd packages
├── locate-tools/     (8 files)  - locate, plocate packages
├── text-tools/       (8 files)  - sed, sd packages
└── utils/            (shared utilities)
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

6. **Test with**: `nix build .#prefer-newtool` and `nix run .#prefer-newtool -- --help`

7. **Update documentation** in AGENTS.md

8. **Test with**: `just test` and `just generate`

### Creating Complete Package Families

When creating a new tool migration (like ripgrep), you need to create all 4 governance variants for each tool:

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
git add wrappers/*grep* wrappers/*ag* wrappers/*git-grep* wrappers/*ucg* wrappers/*pt* wrappers/*sift*
git add nix/*grep* nix/*ag* nix/*git-grep* nix/*ucg* nix/*pt* nix/*sift*
git add flake.nix AGENTS.md

# 5. Test individual packages
nix build .#prefer-grep && nix run .#prefer-grep -- --help
nix build .#force-ag && nix run .#force-ag -- "test" .
nix build .#block-sift && nix run .#block-sift -- --version

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
just generate

# Or specific ecosystems
just generate-internal
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

### Running Tests

```bash
# Quick functionality tests
just test

# Ripgrep-specific tests (24 packages)
just test-ripgrep

# Comprehensive test suite
just test-comprehensive

# Individual package testing
just test-internal
```

### Test Coverage

- **115 individual governance packages tested** (13 existing + 24 search tools + 44 new system tools + 34 extended packages)
- **11 bundle packages tested**
- **126 test scenarios total**
- **Transient devbox environments for isolation**

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
nix build .#prefer-pnpm
nix build .#command-governance

# Run governed commands
nix run .#prefer-pnpm -- --version
```

## Available Packages

### Node.js Governance (12 packages)
- **npm → pnpm**: `prefer-pnpm`, `eject-npm`, `force-pnpm`, `block-npm`
- **npm → yarn**: `prefer-yarn`, `eject-yarn`, `force-yarn`, `block-yarn`
- **npm → bun**: `prefer-bun`, `eject-bun`, `force-bun`, `block-bun`

### Python Governance (3 packages)
- **pip → uv**: `prefer-uv`, `eject-pip`, `block-pip`

### Search Tool Governance (24 packages)

#### ripgrep → Traditional Search Tools
- **grep → ripgrep**: `prefer-grep`, `eject-grep`, `force-grep`, `block-grep`
- **ag → ripgrep**: `prefer-ag`, `eject-ag`, `force-ag`, `block-ag`
- **git grep → ripgrep**: `prefer-git-grep`, `eject-git-grep`, `force-git-grep`, `block-git-grep`
- **ucg → ripgrep**: `prefer-ucg`, `eject-ucg`, `force-ucg`, `block-ucg`
- **pt → ripgrep**: `prefer-pt`, `eject-pt`, `force-pt`, `block-pt`
- **sift → ripgrep**: `prefer-sift`, `eject-sift`, `force-sift`, `block-sift`

#### Individual Package Details
- **`prefer-grep`** - Soft guidance preferring ripgrep over traditional grep
- **`prefer-ag`** - Soft guidance preferring ripgrep over the_silver_searcher
- **`prefer-git-grep`** - Soft guidance preferring ripgrep over git grep
- **`prefer-ucg`** - Soft guidance preferring ripgrep over Universal Code Grep
- **`prefer-pt`** - Soft guidance preferring ripgrep over the_platinum_searcher
- **`prefer-sift`** - Soft guidance preferring ripgrep over sift

#### Enforcement Packages
- **`eject-*`** - Removes disfavored search tool if possible
- **`force-*`** - Forces disfavored tool to use ripgrep (e.g., `force-grep` makes grep command run ripgrep)
- **`block-*`** - Complete prohibition with error-exiting wrappers

### Privilege Tool Governance (8 packages)

#### sudo → Modern Privilege Tools
- **sudo → sudo-rs**: `prefer-sudo`, `eject-sudo`, `force-sudo`, `block-sudo`
- **sudo → doas**: `prefer-sudo-doas`, `eject-sudo-doas`, `force-sudo-doas`, `block-sudo-doas`
- **pkexec → sudo**: `prefer-pkexec`, `eject-pkexec`, `force-pkexec`, `block-pkexec`

#### Individual Package Details
- **`prefer-sudo`** - Soft guidance preferring sudo-rs over traditional sudo
- **`prefer-sudo-doas`** - Soft guidance preferring doas over sudo for simplicity
- **`prefer-pkexec`** - Soft guidance preferring sudo over pkexec for consistency

#### Why sudo-rs/doas?
- **sudo-rs**: Rust implementation with memory safety and reduced attack surface
- **doas**: Minimalist alternative from OpenBSD, simpler configuration
- **Better security**: Reduced code complexity and modern security practices

### Download Tool Governance (10 packages)

#### curl → Modern Download Tools
- **curl → wget**: `prefer-curl`, `eject-curl`, `force-curl`, `block-curl`
- **curl → httpie**: `prefer-curl-httpie`, `eject-curl-httpie`, `force-curl-httpie`, `block-curl-httpie`
- **wget → aria2**: `prefer-wget`, `eject-wget`, `force-wget`, `block-wget`
- **wget2 → curl**: `prefer-wget2`, `eject-wget2`, `force-wget2`, `block-wget2`

#### Individual Package Details
- **`prefer-curl`** - Soft guidance preferring wget over curl for download scripts
- **`prefer-curl-httpie`** - Soft guidance preferring httpie for API debugging
- **`prefer-wget`** - Soft guidance preferring aria2 for parallel downloads
- **`prefer-wget2`** - Soft guidance preferring curl over wget2 for compatibility

#### Tool Comparison
- **curl**: Versatile, supports many protocols, script-friendly
- **wget**: Recursive downloads, robust for mirroring
- **httpie**: User-friendly JSON/API debugging with syntax highlighting
- **aria2**: Multi-connection downloads, supports various protocols
- **wget2**: Modern wget rewrite with improved performance

### Find Tool Governance (8 packages)

#### find → fd
- **find → fd**: `prefer-find`, `eject-find`, `force-find`, `block-find`
- **fd → find**: `prefer-fd`, `eject-fd`, `force-fd`, `block-fd`

#### Individual Package Details
- **`prefer-find`** - Soft guidance preferring fd over traditional find
- **`prefer-fd`** - Soft guidance preferring find over fd for complex expressions

#### Why fd?
- **Intuitive defaults**: Ignores hidden files and respects .gitignore
- **Fast performance**: Rust-based with parallel execution
- **Developer-friendly**: Colored output and sane defaults
- **Simple syntax**: Regular expressions instead of complex find expressions

### Locate Tool Governance (8 packages)

#### locate → plocate
- **locate → plocate**: `prefer-locate`, `eject-locate`, `force-locate`, `block-locate`
- **plocate → locate**: `prefer-plocate`, `eject-plocate`, `force-plocate`, `block-plocate`

#### Individual Package Details
- **`prefer-locate`** - Soft guidance preferring plocate over traditional locate
- **`prefer-plocate`** - Soft guidance preferring locate over plocate for compatibility

#### Why plocate?
- **Better performance**: Uses posting lists for faster searches
- **Modern implementation**: Improved indexing and search algorithms
- **Compatibility**: Drop-in replacement for traditional locate/updatedb

### Text Processing Tool Governance (8 packages)

#### sed → sd
- **sed → sd**: `prefer-sed`, `eject-sed`, `force-sed`, `block-sed`
- **sd → sed**: `prefer-sd`, `eject-sd`, `force-sd`, `block-sd`

#### Individual Package Details
- **`prefer-sed`** - Soft guidance preferring sd over sed for simple replacements
- **`prefer-sd`** - Soft guidance preferring sed over sd for complex scripts

#### Why sd?
- **Intuitive syntax**: Uses regular expressions more familiar to developers
- **Safer by default**: Doesn't modify files in-place unless explicitly requested
- **Better error handling**: Clear error messages and safer operations
- **Performance**: Fast Rust implementation for common use cases

### Bundle Packages (11 packages)
- **`nodejs-ecosystem`** - All Node.js package manager governance
- **`python-ecosystem`** - Python package manager governance
- **`dev-tools`** - Development tool governance
- **`migrate-to-pnpm-bundle`** - Complete npm→pnpm migration
- **`migrate-to-uv-bundle`** - Complete pip→uv migration
- **`privilege-tools`** - All privilege escalation tool governance
- **`download-tools`** - All download tool governance
- **`find-tools`** - All file finding tool governance
- **`locate-tools`** - All file locating tool governance
- **`text-tools`** - All text processing tool governance
- **`command-governance`** - All 115 governance packages (47 existing + 24 search tools + 44 new system tools)

## Search Tool Governance: ripgrep

### Overview

The `prefer-ripgrep` package family provides governance for search tools, encouraging the use of `ripgrep (rg)` over alternative search tools like `grep`, `ag` (the_silver_searcher), `git grep`, `ucg`, `pt` (the_platinum_searcher), and `sift`.

### Why ripgrep?

**ripgrep** is a modern, high-performance search tool that combines the best features of traditional search tools with significant performance improvements:

- **Blazing fast**: Often 10-100x faster than traditional grep
- **Intelligent defaults**: Automatically respects `.gitignore` and skips binary files
- **Modern regex**: Uses Rust's regex engine with better Unicode support
- **Parallel execution**: Utilizes multiple CPU cores automatically
- **Built for developers**: Designed specifically for code search workflows

### Replaced Tools

The `prefer-ripgrep` package provides soft guidance for these alternatives:

- **`grep`** - Traditional Unix search tool
- **`ag`** - The Silver Searcher
- **`git grep`** - Git's built-in search
- **`ucg`** - Universal Code Grep
- **`pt`** - The Platinum Searcher
- **`sift`** - Fast text search tool

### Usage Examples

```bash
# Basic search (replaces grep -r)
rg "pattern" .

# Search with file type filtering
rg "function" --type js

# Search only in specific files
rg "TODO" --glob "*.md"

# Context lines (replaces grep -C)
rg "error" --context 3

# Case-insensitive search
rg "error" --ignore-case

# Regex search with word boundaries
rg "\berror\b"
```

### Performance Comparison

Typical performance improvements over traditional tools:
- **vs grep**: 10-100x faster on large codebases
- **vs ag**: Similar performance but better memory usage
- **vs git grep**: Faster and more flexible
- **vs pt/sift**: Better regex engine and Unicode support

### Package Details

- **Package family**: `prefer-ripgrep` ecosystem (24 packages)
- **Governance types**: Soft guidance, enforcement, strict replacement, complete prohibition
- **Dependencies**: `ripgrep` (rg) must be installed for force/block variants
- **Bundle inclusion**: Available in `dev-tools` and `command-governance`
- **Coverage**: 6 traditional search tools with 4 governance variants each

### Reference

For comprehensive documentation, examples, and installation instructions, visit the official ripgrep website:
**https://burntsushi.net/ripgrep/**

The site provides detailed usage guides, performance benchmarks, and configuration examples for integrating ripgrep into your development workflow.

## Common Tasks

### Add New Tool Migration

1. Create wrapper scripts in `wrappers/`
2. Create Nix derivations in `nix/`
3. Update `flake.nix` packages section
4. Add to packaging generators
5. Update bundle packages
6. Test with `just test`

### Debug Package Issues

```bash
# Test individual package
nix run .#prefer-pnpm -- --version

# Check wrapper script
cat wrappers/npm.prefer-pnpm.sh

# Verify Nix derivation
nix build .#prefer-pnpm --print-build-logs
```

### Release Process

```bash
# Build and test everything
just build && just test

# Generate all packaging
just generate

# Create release artifacts
just release
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
just doctor

# See available commands
just --list

# Test specific package
nix run .#package-name -- --help
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
