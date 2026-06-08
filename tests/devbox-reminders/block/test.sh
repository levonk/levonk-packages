#!/usr/bin/env sh
PASS=0; FAIL=0
test_package() {
  package="$1"
  # Handle special command name mappings
  case "$package" in
    block-gpp)
      cmd_name="g++"
      ;;
    block-git-grep)
      cmd_name="git-grep"
      ;;
    block-bun|block-bun-from-pnpm|block-bun-from-yarn)
      cmd_name="npm"  # block-bun packages wrap npm, not bun
      ;;
    block-yarn|block-yarn-from-pnpm|block-yarn-from-bun)
      cmd_name="npm"  # block-yarn packages wrap npm, not yarn
      ;;
    block-*-from-*)
      # Extract base tool name from "block-tool-from-source" 
      cmd_name=$(echo "$1" | sed 's/^block-//' | sed 's/-from-.*//')
      ;;
    *)
      cmd_name=$(echo "$1" | sed 's/^block-//')
      ;;
  esac
  
  echo "[$package] Testing..."
  
  # Test --version (should fail with block message)
  output=$($cmd_name --version 2>&1)
  status=$?
  
  if [ $status -eq 0 ]; then 
    echo "  FAIL: exit 0 (should be blocked)"
    FAIL=$((FAIL+1))
  else
    # Filter out common governance messages and check if actual tool output remains
    unexpected=$(echo "$output" | rg -v "blocked by policy" | rg -v "must use" | rg -v "jetify" | rg -v "devbox" | rg -v "deprecated" | rg -v "Use yarn instead" | rg -v "Use bun instead" | rg -v "Use pnpm instead" | rg -v "Use npm instead" | rg -v "Install" | rg -v "https://" | rg -v "❌" | rg -v "💡" | rg -v "📚" | rg -v "^$")
    if [ -z "$unexpected" ]; then 
      echo "  PASS"
      PASS=$((PASS+1))
    else 
      echo "  FAIL: unexpected output: $unexpected"
      FAIL=$((FAIL+1))
    fi
  fi
  echo ""
}

# Test ALL block packages (37 total)
test_package "block-ag"
test_package "block-bun"
test_package "block-bun-from-pnpm"
test_package "block-bun-from-yarn"
test_package "block-cargo"
test_package "block-clang"
test_package "block-cmake"
test_package "block-dotnet"
test_package "block-gcc"
test_package "block-gem"
test_package "block-git-grep"
test_package "block-go"
test_package "block-gpp"
test_package "block-grep"
test_package "block-java"
test_package "block-javac"
test_package "block-just"
test_package "block-make"
test_package "block-ninja"
test_package "block-node"
test_package "block-npm"
test_package "block-npm-from-bun"
test_package "block-npm-from-yarn"
test_package "block-pip"
test_package "block-pip3"
test_package "block-pnpm"
test_package "block-pnpm-from-bun"
test_package "block-pnpm-from-yarn"
test_package "block-pt"
test_package "block-python"
test_package "block-python3"
test_package "block-ruby"
test_package "block-rustc"
test_package "block-sift"
test_package "block-swift"
test_package "block-tsc"
test_package "block-ucg"
test_package "block-uv"
test_package "block-yarn"
test_package "block-yarn-from-bun"
test_package "block-yarn-from-pnpm"

echo "block: $PASS passed, $FAIL failed"
