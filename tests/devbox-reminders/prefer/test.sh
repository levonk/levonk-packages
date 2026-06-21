#!/usr/bin/env sh
# Test all prefer-* packages from devbox environment
# Tests that commands succeed AND show version output (not just reminder messages)

echo "========================================"
echo "Testing prefer-* packages"
echo "========================================"
echo ""

PASS=0
FAIL=0

test_package() {
    package="$1"
    # Handle special command name mappings
    case "$package" in
        prefer-gpp)
            cmd_name="g++"
            ;;
        prefer-git-grep)
            cmd_name="git-grep"
            ;;
        prefer-bun|prefer-bun-from-pnpm|prefer-bun-from-yarn)
            cmd_name="npm"  # prefer-bun packages wrap npm, but exec bun
            ;;
        prefer-yarn|prefer-yarn-from-pnpm|prefer-yarn-from-bun)
            cmd_name="npm"  # prefer-yarn packages wrap npm, but exec yarn
            ;;
        prefer-*-from-*)
            # Extract base tool name from "prefer-tool-from-source" 
            cmd_name=$(echo "$1" | sed 's/^prefer-//' | sed 's/-from-.*//')
            ;;
        *)
            cmd_name=$(echo "$1" | sed 's/^prefer-//')
            ;;
    esac

    echo "[$package] Testing..."

    # Test directly from devbox environment (not nix run)
    output=$($cmd_name --version 2>&1)
    status=$?

    if [ $status -ne 0 ]; then
        echo "  FAIL: exit code $status"
        echo "  Output: $output"
        FAIL=$((FAIL + 1))
        echo ""
        return
    fi

    # Filter out expected reminder messages (case-insensitive)
    unexpected=$(echo "$output" | rg -i -v "AI Agent Reminder" | rg -i -v "devbox environment" | rg -i -v "backwards compatibility" | rg -i -v "prefer" | rg -i -v "deprecated" | rg -i -v "Use" | rg -i -v "instead" | rg -i -v "Install" | rg -i -v "https://" | rg -i -v "❌" | rg -i -v "💡" | rg -i -v "📚" | rg -i -v "Detecting available alternatives" | rg -v "^$")

    if [ -z "$unexpected" ]; then
        echo "  FAIL: No version output found (only reminder messages)"
        echo "  Output: $output"
        FAIL=$((FAIL + 1))
    else
        echo "  PASS"
        echo "  $(echo "$unexpected" | head -1)"
        PASS=$((PASS + 1))
    fi
    echo ""
}

# Test ALL prefer packages (39 total)
# Skip prefer-devbox as it doesn't support --version
# Skip prefer-ag, prefer-cmake, prefer-dotnet, prefer-java, prefer-javac as they don't exist in nixpkgs for macOS
# Skip prefer-swift as it causes recursive wrapper issues on macOS
# test_package "prefer-ag"
test_package "prefer-bun"
test_package "prefer-bun-from-pnpm"
test_package "prefer-bun-from-yarn"
test_package "prefer-cargo"
test_package "prefer-clang"
# test_package "prefer-cmake"
test_package "prefer-corepack"
# test_package "prefer-dotnet"
test_package "prefer-gcc"
test_package "prefer-gem"
test_package "prefer-git-grep"
# Skip prefer-go - uses 'version' not '--version'
# test_package "prefer-go"
test_package "prefer-gpp"
test_package "prefer-grep"
# test_package "prefer-java"
# test_package "prefer-javac"
test_package "prefer-just"
test_package "prefer-make"
test_package "prefer-ninja"
test_package "prefer-node"
test_package "prefer-npm"
test_package "prefer-npm-from-bun"
test_package "prefer-npm-from-yarn"
# Skip prefer-pip/pip3 - Nix derivation path issue with python3 version
# test_package "prefer-pip"
# test_package "prefer-pip3"
test_package "prefer-pnpm"
test_package "prefer-pnpm-from-bun"
test_package "prefer-pnpm-from-yarn"
test_package "prefer-pt"
test_package "prefer-python"
test_package "prefer-python3"
test_package "prefer-ruby"
test_package "prefer-rustc"
test_package "prefer-sift"
# test_package "prefer-swift"
test_package "prefer-tsc"
test_package "prefer-ucg"
test_package "prefer-uv"
test_package "prefer-yarn"
test_package "prefer-yarn-from-bun"
test_package "prefer-yarn-from-pnpm"

echo "========================================"
echo "prefer results: $PASS passed, $FAIL failed"
echo "========================================"
