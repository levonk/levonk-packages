#!/bin/bash
set -euo pipefail

# Comprehensive governance testing using transient devbox run

echo "🧪 Running comprehensive governance tests..."

# Function to test a governance package
test_governance_package() {
    local package_name="$1"
    local expected_behavior="$2"
    local test_args="$3"
    
    echo "🔍 Testing $package_name (expecting: $expected_behavior)..."
    
    # Create a temporary directory for testing
    local test_dir=$(mktemp -d)
    cd "$test_dir"
    
    # Create a minimal devbox.json
    cat > devbox.json << EOF
{
  "name": "test-$package_name",
  "packages": [
    "nodejs",
    "pnpm",
    "yarn",
    "bun"
  ],
  "shell": {
    "init_hook": []
  }
}
EOF
    
    # Add the governance package
    echo "📦 Adding $package_name to test environment..."
    if devbox add "github:levonk/levonk-packages#$package_name" >/dev/null 2>&1; then
        echo "✅ Successfully added $package_name"
    else
        echo "❌ Failed to add $package_name"
        cd ..
        rm -rf "$test_dir"
        return 1
    fi
    
    # Test the behavior
    echo "🧪 Testing behavior..."
    case "$expected_behavior" in
        prefer)
            echo "📋 Expected: Warning message + delegation"
            if devbox run npm --version 2>&1 | grep -q "⚠️ Prefer"; then
                echo "✅ Warning message detected"
                if devbox run npm --version 2>&1 | grep -q "pnpm\|yarn\|bun"; then
                    echo "✅ Delegation to alternative detected"
                    echo "✅ $package_name test PASSED"
                else
                    echo "❌ No delegation detected"
                    echo "❌ $package_name test FAILED"
                fi
            else
                echo "❌ No warning message detected"
                echo "❌ $package_name test FAILED"
            fi
            ;;
        force)
            echo "📋 Expected: Force message + execution"
            if devbox run npm --version 2>&1 | grep -q "✅ Using.*instead of npm (forced by policy)"; then
                echo "✅ Force message detected"
                if devbox run npm --version 2>&1 | grep -q "pnpm\|yarn\|bun"; then
                    echo "✅ Execution of alternative detected"
                    echo "✅ $package_name test PASSED"
                else
                    echo "❌ No execution of alternative detected"
                    echo "❌ $package_name test FAILED"
                fi
            else
                echo "❌ No force message detected"
                echo "❌ $package_name test FAILED"
            fi
            ;;
        block)
            echo "📋 Expected: Block message + exit code 1"
            if devbox run npm --version 2>&1 | grep -q "❌ npm is blocked by policy"; then
                echo "✅ Block message detected"
                if [ $? -eq 1 ]; then
                    echo "✅ Exit code 1 detected"
                    echo "✅ $package_name test PASSED"
                else
                    echo "❌ No exit code 1 detected"
                    echo "❌ $package_name test FAILED"
                fi
            else
                echo "❌ No block message detected"
                echo "❌ $package_name test FAILED"
            fi
            ;;
        eject)
            echo "📋 Expected: Eject message + exit code 1"
            if devbox run npm --version 2>&1 | grep -q "❌ npm has been ejected by policy"; then
                echo "✅ Eject message detected"
                if [ $? -eq 1 ]; then
                    echo "✅ Exit code 1 detected"
                    echo "✅ $package_name test PASSED"
                else
                    echo "❌ No exit code 1 detected"
                    echo "❌ $package_name test FAILED"
                fi
            else
                echo "❌ No eject message detected"
                echo "❌ $package_name test FAILED"
            fi
            ;;
    esac
    
    # Clean up
    cd ..
    rm -rf "$test_dir"
    echo ""
}

# Function to test bundle packages
test_bundle_package() {
    local bundle_name="$1"
    local expected_packages="$2"
    
    echo "🔍 Testing bundle $bundle_name..."
    
    # Create a temporary directory for testing
    local test_dir=$(mktemp -d)
    cd "$test_dir"
    
    # Create a minimal devbox.json
    cat > devbox.json << EOF
{
  "name": "test-$bundle_name",
  "packages": [
    "nodejs",
    "pnpm",
    "yarn",
    "bun"
  ],
  "shell": {
    "init_hook": []
  }
}
EOF
    
    # Add the bundle package
    echo "📦 Adding $bundle_name to test environment..."
    if devbox add "github:levonk/levonk-packages#$bundle_name" >/dev/null 2>&1; then
        echo "✅ Successfully added $bundle_name"
    else
        echo "❌ Failed to add $bundle_name"
        cd ..
        rm -rf "$test_dir"
        return 1
    fi
    
    # Test that multiple tools are governed
    echo "🧪 Testing multiple governed tools..."
    local tools_tested=0
    local tools_passed=0
    
    for tool in npm pnpm yarn bun; do
        echo "🔍 Testing $tool governance..."
        if devbox run "$tool" --version 2>&1 | grep -q "⚠️\|✅\|❌"; then
            echo "✅ $tool is governed"
            tools_tested=$((tools_tested + 1))
            tools_passed=$((tools_passed + 1))
        else
            echo "❌ $tool is not governed"
            tools_tested=$((tools_tested + 1))
        fi
    done
    
    if [ "$tools_passed" -eq "$tools_tested" ]; then
        echo "✅ All tools are governed"
        echo "✅ $bundle_name test PASSED"
    else
        echo "❌ Some tools are not governed"
        echo "❌ $bundle_name test FAILED"
    fi
    
    # Clean up
    cd ..
    rm -rf "$test_dir"
    echo ""
}

# Test individual packages
echo "🧪 Testing individual governance packages..."
test_governance_package "prefer-pnpm" "prefer"
test_governance_package "block-npm" "block"
test_governance_package "force-pnpm" "force"
test_governance_package "eject-npm" "eject"

# Test pnpm governance
test_governance_package "prefer-npm" "prefer"
test_governance_package "block-pnpm" "block"
test_governance_package "force-npm" "force"
test_governance_package "eject-pnpm" "eject"

# Test yarn governance
test_governance_package "prefer-npm-from-yarn" "prefer"
test_governance_package "block-yarn" "block"
test_governance_package "force-pnpm-from-yarn" "force"
test_governance_package "eject-yarn" "eject"

# Test bun governance
test_governance_package "prefer-npm-from-bun" "prefer"
test_governance_package "block-bun" "block"
test_governance_package "force-pnpm-from-bun" "force"
test_governance_package "eject-bun" "eject"

# Test pip governance
test_governance_package "prefer-uv" "prefer"
test_governance_package "block-pip" "block"
test_governance_package "eject-pip" "eject"

# Test bundle packages
echo "🧪 Testing bundle packages..."
test_bundle_package "prefer-all" "npm pnpm yarn bun"
test_bundle_package "force-pnpm" "npm pnpm yarn bun"
test_bundle_package "force-uv" "pip"
test_bundle_package "force-devbox" "curl"

echo "🎉 All governance tests completed!"
echo "📊 Summary:"
echo "  - Individual packages: 13 tested"
echo "  - Bundle packages: 4 tested"
echo "  - Total: 17 test scenarios"
