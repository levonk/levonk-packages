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

# Test force packages (exclude force-devbox.sh packages which create loops)
test_package "force-ag"
test_package "force-bun"
test_package "force-bun-from-pnpm"
test_package "force-bun-from-yarn"
# Skip force-cargo (uses force-devbox.sh which creates loop)
# Skip force-clang (uses force-devbox.sh which creates loop)
# Skip force-cmake (uses force-devbox.sh which creates loop)
# Skip force-dotnet (uses force-devbox.sh which creates loop)
# Skip force-gcc (uses force-devbox.sh which creates loop)
# Skip force-gem (uses force-devbox.sh which creates loop)
test_package "force-git-grep"
# Skip force-go (uses force-devbox.sh which creates loop)
# Skip force-gpp (uses force-devbox.sh which creates loop)
test_package "force-grep"
# Skip force-java (uses force-devbox.sh which creates loop)
# Skip force-javac (uses force-devbox.sh which creates loop)
# Skip force-just (uses force-devbox.sh which creates loop)
# Skip force-make (uses force-devbox.sh which creates loop)
# Skip force-ninja (uses force-devbox.sh which creates loop)
# Skip force-node (uses force-devbox.sh which creates loop)
test_package "force-npm"
test_package "force-npm-from-bun"
test_package "force-npm-from-yarn"
# Skip force-pip (uses force-devbox.sh which creates loop)
# Skip force-pip3 (uses force-devbox.sh which creates loop)
test_package "force-pnpm"
test_package "force-pnpm-from-bun"
test_package "force-pnpm-from-yarn"
test_package "force-pt"
# Skip force-python (uses force-devbox.sh which creates loop)
# Skip force-python3 (uses force-devbox.sh which creates loop)
# Skip force-ruby (uses force-devbox.sh which creates loop)
# Skip force-rustc (uses force-devbox.sh which creates loop)
test_package "force-sift"
# Skip force-swift (uses force-devbox.sh which creates loop)
# Skip force-tsc (uses force-devbox.sh which creates loop)
test_package "force-ucg"
# Skip force-uv (uses force-devbox.sh which creates loop)
test_package "force-yarn"
test_package "force-yarn-from-bun"
test_package "force-yarn-from-pnpm"

echo "force: $PASS passed, $FAIL failed"
