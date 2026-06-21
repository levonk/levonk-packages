#!/bin/bash
set -euo pipefail

# Unified Governance Test Framework
# Standardized testing for all governance packages

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Test configuration
TEST_CONFIG_FILE="$PROJECT_ROOT/test-config.toml"
RESULTS_DIR="$PROJECT_ROOT/test-results"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Load test configuration
load_config() {
    if [[ -f "$TEST_CONFIG_FILE" ]]; then
        log_info "Loading test configuration from $TEST_CONFIG_FILE"
        # TODO: Parse TOML config when available
    else
        log_warning "No test configuration found, using defaults"
    fi
}

# Test a single governance package
test_package() {
    local package_name="$1"
    local expected_behavior="$2"
    
    log_info "Testing $package_name ($expected_behavior)"
    
    # Create test results directory
    mkdir -p "$RESULTS_DIR"
    
    # Test if package builds
    if ! nix build ".#$package_name" --print-build-logs > "$RESULTS_DIR/${package_name}-build.log" 2>&1; then
        log_error "$package_name failed to build"
        echo "FAILED" > "$RESULTS_DIR/${package_name}-result.txt"
        return 1
    fi
    
    # Test package behavior based on type
    case "$expected_behavior" in
        prefer)
            test_prefer_package "$package_name"
            ;;
        force)
            test_force_package "$package_name"
            ;;
        block)
            test_block_package "$package_name"
            ;;
        eject)
            test_eject_package "$package_name"
            ;;
        rtk-wrap)
            test_rtk_wrap_package "$package_name"
            ;;
        devbox-auto)
            test_devbox_auto_package "$package_name"
            ;;
        *)
            log_error "Unknown behavior type: $expected_behavior"
            return 1
            ;;
    esac
}

# Test prefer packages
test_prefer_package() {
    local package_name="$1"
    local output
    output=$(nix run ".#$package_name" -- --help 2>&1 || true)
    
    if echo "$output" | grep -q "⚠️ Prefer"; then
        log_success "Warning message detected"
        echo "PASSED" > "$RESULTS_DIR/${package_name}-result.txt"
    else
        log_error "No warning message detected"
        echo "FAILED" > "$RESULTS_DIR/${package_name}-result.txt"
    fi
}

# Test force packages
test_force_package() {
    local package_name="$1"
    local output
    output=$(nix run ".#$package_name" -- --help 2>&1 || true)
    
    if echo "$output" | grep -q "ripgrep\|pnpm\|yarn\|bun\|uv"; then
        log_success "Force execution detected"
        echo "PASSED" > "$RESULTS_DIR/${package_name}-result.txt"
    else
        log_error "No force execution detected"
        echo "FAILED" > "$RESULTS_DIR/${package_name}-result.txt"
    fi
}

# Test block packages
test_block_package() {
    local package_name="$1"
    local output
    output=$(nix run ".#$package_name" -- --version 2>&1 || true)
    
    if echo "$output" | grep -q "❌.*is deprecated\|❌.*is blocked"; then
        log_success "Block message detected"
        echo "PASSED" > "$RESULTS_DIR/${package_name}-result.txt"
    else
        log_error "No block message detected"
        echo "FAILED" > "$RESULTS_DIR/${package_name}-result.txt"
    fi
}

# Test eject packages
test_eject_package() {
    local package_name="$1"
    local output
    output=$(nix run ".#$package_name" -- --help 2>&1 || true)
    
    if echo "$output" | grep -q "🚀 Ejecting"; then
        log_success "Eject message detected"
        echo "PASSED" > "$RESULTS_DIR/${package_name}-result.txt"
    else
        log_error "No eject message detected"
        echo "FAILED" > "$RESULTS_DIR/${package_name}-result.txt"
    fi
}

# Test RTK wrap packages
test_rtk_wrap_package() {
    local package_name="$1"
    local output
    # Set RTK_WRAPPER_IN_PROGRESS to test recursion prevention
    export RTK_WRAPPER_IN_PROGRESS=1
    output=$(nix run ".#$package_name" -- --version 2>&1 || true)
    unset RTK_WRAPPER_IN_PROGRESS
    
    # Should fall back to native command when RTK_WRAPPER_IN_PROGRESS is set
    if echo "$output" | grep -q "version\|Version"; then
        log_success "RTK wrapper with recursion prevention works"
        echo "PASSED" > "$RESULTS_DIR/${package_name}-result.txt"
    else
        log_error "RTK wrapper recursion prevention failed"
        echo "FAILED" > "$RESULTS_DIR/${package_name}-result.txt"
    fi
}

# Test devbox-auto packages
test_devbox_auto_package() {
    local package_name="$1"
    local output
    # Set DEVBOX_AUTO_IN_PROGRESS to test recursion prevention
    export DEVBOX_AUTO_IN_PROGRESS=1
    output=$(nix run ".#$package_name" -- --version 2>&1 || true)
    unset DEVBOX_AUTO_IN_PROGRESS
    
    # Should fall back to native command when DEVBOX_AUTO_IN_PROGRESS is set
    if echo "$output" | grep -q "version\|Version\|command not found"; then
        log_success "Devbox-auto wrapper with recursion prevention works"
        echo "PASSED" > "$RESULTS_DIR/${package_name}-result.txt"
    else
        log_error "Devbox-auto wrapper recursion prevention failed"
        echo "FAILED" > "$RESULTS_DIR/${package_name}-result.txt"
    fi
}

# Test package family (all variants of a tool)
test_package_family() {
    local tool="$1"
    local variants=("prefer" "force" "block" "eject")
    
    log_info "Testing $tool family"
    
    for variant in "${variants[@]}"; do
        local package_name="${variant}-${tool}"
        if nix flake metadata --json 2>/dev/null | grep -q "\"$package_name\""; then
            test_package "$package_name" "$variant"
        else
            log_warning "Package $package_name not found, skipping"
        fi
    done
}

# Generate test report
generate_report() {
    local total_tests=0
    local passed_tests=0
    local failed_tests=0
    
    log_info "Generating test report..."
    
    for result_file in "$RESULTS_DIR"/*-result.txt; do
        if [[ -f "$result_file" ]]; then
            total_tests=$((total_tests + 1))
            local result=$(cat "$result_file")
            if [[ "$result" == "PASSED" ]]; then
                passed_tests=$((passed_tests + 1))
            else
                failed_tests=$((failed_tests + 1))
                local package_name=$(basename "$result_file" "-result.txt")
                log_error "$package_name failed"
            fi
        fi
    done
    
    echo ""
    log_info "Test Summary:"
    echo "  Total tests: $total_tests"
    echo "  Passed: $passed_tests"
    echo "  Failed: $failed_tests"
    
    if [[ $failed_tests -eq 0 ]]; then
        log_success "All tests passed!"
        return 0
    else
        log_error "$failed_tests tests failed"
        return 1
    fi
}

# Main execution
main() {
    local test_target="${1:-all}"
    
    load_config
    
    case "$test_target" in
        all)
            log_info "Running all governance tests..."
            # Test all package families
            test_package_family "pnpm"
            test_package_family "npm"
            test_package_family "yarn"
            test_package_family "bun"
            test_package_family "pip"
            test_package_family "grep"
            # Test RTK wrapper packages
            test_rtk_wrap_package "rtk-wrap-ls"
            test_rtk_wrap_package "rtk-wrap-git"
            test_rtk_wrap_package "rtk-wrap-npm"
            # Test devbox-auto packages
            test_devbox_auto_package "devbox-auto-npm"
            test_devbox_auto_package "devbox-auto-python"
            test_devbox_auto_package "devbox-auto-cargo"
            test_package_family "ag"
            test_package_family "git-grep"
            test_package_family "ucg"
            test_package_family "pt"
            test_package_family "sift"
            ;;
        nodejs)
            log_info "Testing Node.js package families..."
            test_package_family "pnpm"
            test_package_family "npm"
            test_package_family "yarn"
            test_package_family "bun"
            ;;
        search)
            log_info "Testing search tool families..."
            test_package_family "grep"
            test_package_family "ag"
            test_package_family "git-grep"
            test_package_family "ucg"
            test_package_family "pt"
            test_package_family "sift"
            ;;
        *)
            if [[ "$test_target" =~ ^(prefer|force|block|eject|rtk-wrap|devbox-auto)-.+$ ]]; then
                local package_name="$test_target"
                local behavior
                case "$test_target" in
                    rtk-wrap-*) behavior="rtk-wrap" ;;
                    devbox-auto-*) behavior="devbox-auto" ;;
                    prefer-*) behavior="prefer" ;;
                    force-*) behavior="force" ;;
                    block-*) behavior="block" ;;
                    eject-*) behavior="eject" ;;
                esac
                test_package "$package_name" "$behavior"
            else
                log_error "Unknown test target: $test_target"
                echo "Usage: $0 [all|nodejs|search|[prefer|force|block|eject|rtk-wrap|devbox-auto]-tool]"
                exit 1
            fi
            ;;
    esac
    
    # Generate report for all cases except individual package tests
    if [[ ! "$test_target" =~ ^(prefer|force|block|eject)-.+$ ]]; then
        generate_report
    fi
}

# Run main function with all arguments
main "$@"
