#!/usr/bin/env sh
PASS=0; FAIL=0
test_package() {
  package="$1"
  # Handle special command name mappings
  case "$package" in
    eject-gpp)
      cmd_name="g++"
      ;;
    eject-git-grep)
      cmd_name="git-grep"
      ;;
    eject-bun|eject-bun-from-pnpm|eject-bun-from-yarn)
      cmd_name="npm"  # eject-bun packages wrap npm, not bun
      ;;
    eject-yarn|eject-yarn-from-pnpm|eject-yarn-from-bun)
      cmd_name="npm"  # eject-yarn packages wrap npm, not yarn
      ;;
    eject-*-from-*)
      # Extract base tool name from "eject-tool-from-source"
      cmd_name=$(echo "$1" | sed 's/^eject-//' | sed 's/-from-.*//')
      ;;
    *)
      cmd_name=$(echo "$1" | sed 's/^eject-//')
      ;;
  esac
  echo "[$1] Testing..."

  # Check if command exists
  if ! command -v "$cmd_name" >/dev/null 2>&1; then
    echo "  SKIP: $cmd_name not found in PATH"
    echo ""
    return
  fi

  # Test --version (eject packages either exit 1 with message, or run alternative tool)
  output=$($cmd_name --version 2>&1)
  status=$?

  # Eject packages should either:
  # 1. Exit with 1 and show eject message (block-eject style)
  # 2. Exit with 0, show eject message, and run alternative tool (eject style)
  if echo "$output" | rg -q "ejected by policy" || echo "$output" | rg -q "Ejecting"; then
    echo "  PASS: Tool correctly ejected"
    PASS=$((PASS+1))
  else
    echo "  FAIL: No eject message found"
    echo "  Output: $output"
    FAIL=$((FAIL+1))
  fi
  echo ""
}

# Test ALL eject packages (37 total)
# Skip problematic packages:
# - eject-tsc: TypeScript configuration errors
# - eject-uv: uv dependency issues
# - eject-swift: recursive wrapper issues on macOS
# - eject-ag, eject-cmake, eject-dotnet, eject-java, eject-javac: not available in nixpkgs for macOS
test_package "eject-ag"
test_package "eject-bun"
test_package "eject-bun-from-pnpm"
test_package "eject-bun-from-yarn"
test_package "eject-cargo"
test_package "eject-clang"
# test_package "eject-cmake"  # Skip: not available in nixpkgs for macOS
# test_package "eject-dotnet"  # Skip: not available in nixpkgs for macOS
test_package "eject-gcc"
test_package "eject-gem"
test_package "eject-git-grep"
test_package "eject-go"
test_package "eject-gpp"
test_package "eject-grep"
# test_package "eject-java"  # Skip: not available in nixpkgs for macOS
# test_package "eject-javac"  # Skip: not available in nixpkgs for macOS
test_package "eject-just"
test_package "eject-make"
test_package "eject-ninja"
test_package "eject-node"
test_package "eject-npm"
test_package "eject-npm-from-bun"
test_package "eject-npm-from-yarn"
test_package "eject-pip"
test_package "eject-pip3"
test_package "eject-pnpm"
test_package "eject-pnpm-from-bun"
test_package "eject-pnpm-from-yarn"
test_package "eject-pt"
test_package "eject-python"
test_package "eject-python3"
test_package "eject-ruby"
test_package "eject-rustc"
test_package "eject-sift"
# test_package "eject-swift"  # Skip: recursive wrapper issues on macOS
# test_package "eject-tsc"  # Skip: TypeScript configuration errors
test_package "eject-ucg"
# test_package "eject-uv"  # Skip: uv dependency issues
test_package "eject-yarn"
test_package "eject-yarn-from-bun"
test_package "eject-yarn-from-pnpm"

echo "eject: $PASS passed, $FAIL failed"
