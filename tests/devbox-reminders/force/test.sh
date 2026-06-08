#!/usr/bin/env sh
PASS=0; FAIL=0
test_package() {
  package="$1"
  # Handle special command name mappings
  case "$package" in
    force-gpp)
      cmd_name="g++"
      ;;
    force-git-grep)
      cmd_name="git-grep"
      ;;
    force-bun|force-bun-from-pnpm|force-bun-from-yarn)
      cmd_name="npm"  # force-bun packages wrap npm, but exec bun
      ;;
    force-yarn|force-yarn-from-pnpm|force-yarn-from-bun)
      cmd_name="npm"  # force-yarn packages wrap npm, but exec yarn
      ;;
    force-*-from-*)
      # Extract base tool name from "force-tool-from-source" 
      cmd_name=$(echo "$1" | sed 's/^force-//' | sed 's/-from-.*//')
      ;;
    *)
      cmd_name=$(echo "$1" | sed 's/^force-//')
      ;;
  esac
  echo "[$1] Testing..."
  
  # Test --version (should succeed and show force message)
  output=$($cmd_name --version 2>&1)
  status=$?
  
  if [ $status -ne 0 ]; then 
    echo "  FAIL: exit $status"
    echo "  Output: $output"
    FAIL=$((FAIL+1))
  else
    # Filter out common governance messages and check if actual tool output remains
    unexpected=$(echo "$output" | rg -v "Forcing devbox run" | rg -v "AI agents should use" | rg -v "deprecated" | rg -v "Use" | rg -v "instead" | rg -v "Install" | rg -v "https://" | rg -v "❌" | rg -v "💡" | rg -v "📚" | rg -v "^$")
    if [ -n "$unexpected" ]; then 
      echo "  PASS: $unexpected"
      PASS=$((PASS+1))
    else 
      echo "  FAIL: No output after filtering"
      FAIL=$((FAIL+1))
    fi
  fi
  echo ""
}

# Test ALL force packages (37 total)
test_package "force-ag"
test_package "force-bun"
test_package "force-bun-from-pnpm"
test_package "force-bun-from-yarn"
test_package "force-cargo"
test_package "force-clang"
test_package "force-cmake"
test_package "force-dotnet"
test_package "force-gcc"
test_package "force-gem"
test_package "force-git-grep"
test_package "force-go"
test_package "force-gpp"
test_package "force-grep"
test_package "force-java"
test_package "force-javac"
test_package "force-just"
test_package "force-make"
test_package "force-ninja"
test_package "force-node"
test_package "force-npm"
test_package "force-npm-from-bun"
test_package "force-npm-from-yarn"
test_package "force-pip"
test_package "force-pip3"
test_package "force-pnpm"
test_package "force-pnpm-from-bun"
test_package "force-pnpm-from-yarn"
test_package "force-pt"
test_package "force-python"
test_package "force-python3"
test_package "force-ruby"
test_package "force-rustc"
test_package "force-sift"
test_package "force-swift"
test_package "force-tsc"
test_package "force-ucg"
test_package "force-uv"
test_package "force-yarn"
test_package "force-yarn-from-bun"
test_package "force-yarn-from-pnpm"

echo "force: $PASS passed, $FAIL failed"
