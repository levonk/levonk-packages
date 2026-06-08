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
  
  # Test --version (should succeed and show eject message)
  output=$($cmd_name --version 2>&1)
  status=$?
  
  if [ $status -ne 0 ]; then 
    echo "  FAIL: exit $status"
    echo "  Output: $output"
    FAIL=$((FAIL+1))
  else
    # Filter out common governance messages and check if actual tool output remains
    unexpected=$(echo "$output" | rg -v "Ejecting direct" | rg -v "AI agents should use" | rg -v "devbox.json not found" | rg -v "Running" | rg -v "deprecated" | rg -v "Use" | rg -v "instead" | rg -v "Install" | rg -v "https://" | rg -v "❌" | rg -v "💡" | rg -v "📚" | rg -v "^$")
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

# Test ALL eject packages (37 total)
test_package "eject-ag"
test_package "eject-bun"
test_package "eject-bun-from-pnpm"
test_package "eject-bun-from-yarn"
test_package "eject-cargo"
test_package "eject-clang"
test_package "eject-cmake"
test_package "eject-dotnet"
test_package "eject-gcc"
test_package "eject-gem"
test_package "eject-git-grep"
test_package "eject-go"
test_package "eject-gpp"
test_package "eject-grep"
test_package "eject-java"
test_package "eject-javac"
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
test_package "eject-swift"
test_package "eject-tsc"
test_package "eject-ucg"
test_package "eject-uv"
test_package "eject-yarn"
test_package "eject-yarn-from-bun"
test_package "eject-yarn-from-pnpm"

echo "eject: $PASS passed, $FAIL failed"
