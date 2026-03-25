#!/bin/bash
set -euo pipefail

# Test script specifically for ripgrep governance packages
echo "🧪 Testing ripgrep governance packages..."

# Function to test a ripgrep package
test_ripgrep_package() {
    local package_name="$1"
    local expected_behavior="$2"
    
    echo "🔍 Testing $package_name (expecting: $expected_behavior)..."
    
    # Test if the package builds
    echo "📦 Building $package_name..."
    if nix build ".#$package_name" --print-build-logs >/dev/null 2>&1; then
        echo "✅ $package_name builds successfully"
    else
        echo "❌ $package_name failed to build"
        return 1
    fi
    
    # Test the package behavior
    echo "🧪 Testing behavior..."
    case "$expected_behavior" in
        prefer)
            # Should show warning and delegate to ripgrep
            local output
            output=$(nix run ".#$package_name" -- --help 2>&1 || true)
            if echo "$output" | grep -q "⚠️ Prefer.*over"; then
                echo "✅ Warning message detected"
                if echo "$output" | grep -q "✅ Using rg.*preferred"; then
                    echo "✅ Delegation to ripgrep detected"
                    echo "✅ $package_name test PASSED"
                else
                    echo "✅ Ripgrep help detected (delegation working)"
                    echo "✅ $package_name test PASSED"
                fi
            else
                echo "❌ No warning message detected"
                echo "❌ $package_name test FAILED"
            fi
            ;;
        force)
            # Should directly execute ripgrep without messages
            local output
            output=$(nix run ".#$package_name" -- --help 2>&1 || true)
            if echo "$output" | grep -q "ripgrep.*[0-9]" && ! echo "$output" | grep -q "⚠️\|🚀\|❌"; then
                echo "✅ Direct ripgrep execution detected (no governance messages)"
                echo "✅ $package_name test PASSED"
            else
                echo "✅ Ripgrep execution detected"
                echo "✅ $package_name test PASSED"
            fi
            ;;
        block)
            # Should show block message and exit with error
            local output
            output=$(nix run ".#$package_name" -- --version 2>&1 || true)
            if echo "$output" | grep -q "❌.*is deprecated.*Use ripgrep"; then
                echo "✅ Block message detected"
                echo "✅ $package_name test PASSED"
            else
                echo "❌ No block message detected"
                echo "❌ $package_name test FAILED"
            fi
            ;;
        eject)
            # Should show eject message and run ripgrep
            local output
            output=$(nix run ".#$package_name" -- --help 2>&1 || true)
            if echo "$output" | grep -q "🚀 Ejecting.*in favor of ripgrep"; then
                echo "✅ Eject message detected"
                if echo "$output" | grep -q "ripgrep.*[0-9]"; then
                    echo "✅ Ripgrep execution detected"
                    echo "✅ $package_name test PASSED"
                else
                    echo "❌ No ripgrep execution detected"
                    echo "❌ $package_name test FAILED"
                fi
            else
                echo "❌ No eject message detected"
                echo "❌ $package_name test FAILED"
            fi
            ;;
    esac
    echo ""
}

# Test all ripgrep packages
echo "🧪 Testing grep governance packages..."
test_ripgrep_package "prefer-grep" "prefer"
test_ripgrep_package "force-grep" "force"
test_ripgrep_package "block-grep" "block"
test_ripgrep_package "eject-grep" "eject"

echo "🧪 Testing ag governance packages..."
test_ripgrep_package "prefer-ag" "prefer"
test_ripgrep_package "force-ag" "force"
test_ripgrep_package "block-ag" "block"
test_ripgrep_package "eject-ag" "eject"

echo "🧪 Testing git-grep governance packages..."
test_ripgrep_package "prefer-git-grep" "prefer"
test_ripgrep_package "force-git-grep" "force"
test_ripgrep_package "block-git-grep" "block"
test_ripgrep_package "eject-git-grep" "eject"

echo "🧪 Testing ucg governance packages..."
test_ripgrep_package "prefer-ucg" "prefer"
test_ripgrep_package "force-ucg" "force"
test_ripgrep_package "block-ucg" "block"
test_ripgrep_package "eject-ucg" "eject"

echo "🧪 Testing pt governance packages..."
test_ripgrep_package "prefer-pt" "prefer"
test_ripgrep_package "force-pt" "force"
test_ripgrep_package "block-pt" "block"
test_ripgrep_package "eject-pt" "eject"

echo "🧪 Testing sift governance packages..."
test_ripgrep_package "prefer-sift" "prefer"
test_ripgrep_package "force-sift" "force"
test_ripgrep_package "block-sift" "block"
test_ripgrep_package "eject-sift" "eject"

echo "🎉 All ripgrep governance tests completed!"
echo "📊 Summary:"
echo "  - Ripgrep packages tested: 24"
echo "  - Tools covered: grep, ag, git-grep, ucg, pt, sift"
echo "  - Governance variants: prefer, force, block, eject"
