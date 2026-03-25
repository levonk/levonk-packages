#!/bin/bash
set -euo pipefail

# Automated Governance Package Generator
# Creates complete governance suites: {prefer,block,eject,force} × {nix,alpine,deb,rpm,arch,brew,mise}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

# Governance types
GOVERNANCE_TYPES=("prefer" "eject" "force" "block")

# Package ecosystems
ECOSYSTEMS=("nix" "alpine" "debian" "fedora" "arch" "brew" "mise")

# Create wrapper script
create_wrapper() {
    local tool="$1"
    local governance_type="$2"
    local preferred=""
    
    # Set preferred alternative based on tool
    case "$tool" in
        npm|pnpm|yarn|bun) preferred="pnpm" ;;
        pip) preferred="uv" ;;
        grep|ag|git-grep|ucg|pt|sift) preferred="ripgrep" ;;
    esac
    
    local wrapper_dir="$PROJECT_ROOT/wrappers"
    local wrapper_file="$wrapper_dir/${tool}.${governance_type}-${tool}.sh"
    
    case "$governance_type" in
        prefer)
            cat > "$wrapper_file" << EOF
#!/usr/bin/env sh
# Source the package detection utility
SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
if [ -f "\$SCRIPT_DIR/utils/detect-packages.sh" ]; then
    . "\$SCRIPT_DIR/utils/detect-packages.sh"
fi

# Detect available alternatives
echo "⚠️ Prefer $preferred over $tool. Detecting available alternatives..."

# List available alternatives
available_found=false
for tool in $preferred; do
    if command -v "\$tool" >/dev/null 2>&1; then
        echo "✅ Using \$tool (preferred)"
        exec "\$tool" "\$@"
    fi
done

# Fallback to preferred tool
echo "🔄 Running $preferred..."
exec $preferred "\$@"
EOF
            ;;
        force)
            cat > "$wrapper_file" << EOF
#!/usr/bin/env sh
exec $preferred "\$@"
EOF
            ;;
        block)
            cat > "$wrapper_file" << EOF
#!/usr/bin/env sh
echo "❌ $tool is deprecated. Use $preferred instead."
echo "💡 Install $preferred: https://$preferred.github.io/"
exit 1
EOF
            ;;
        eject)
            cat > "$wrapper_file" << EOF
#!/usr/bin/env sh
echo "🚀 Ejecting $tool in favor of $preferred..."
echo "💡 To install $preferred: https://$preferred.github.io/"
echo "🔄 Running $preferred..."
exec $preferred "\$@"
EOF
            ;;
    esac
    
    chmod +x "$wrapper_file"
    log_success "Created wrapper: $wrapper_file"
}

# Create Nix derivation
create_nix_derivation() {
    local tool="$1"
    local governance_type="$2"
    local binary_name="$tool"
    
    # Special case for git-grep
    if [[ "$tool" == "git-grep" ]]; then
        binary_name="git-grep"
    fi
    
    local nix_file="$PROJECT_ROOT/nix/${governance_type}-${tool}.nix"
    
    cat > "$nix_file" << EOF
{ pkgs }:

pkgs.writeShellScriptBin "$binary_name" ''
  #!/usr/bin/env sh
  \${builtins.readFile ../wrappers/${tool}.${governance_type}-${tool}.sh}
''
EOF
    
    log_success "Created Nix derivation: $nix_file"
}

# Update flake.nix
update_flake() {
    local tool="$1"
    local governance_type="$2"
    local binary_name="$tool"
    
    if [[ "$tool" == "git-grep" ]]; then
        binary_name="git-grep"
    fi
    
    # Add to imports section
    if ! grep -q "${governance_type}-${tool} = import" "$PROJECT_ROOT/flake.nix"; then
        # Find the line with other similar imports
        local insert_line
        case "$governance_type" in
            prefer*)
                insert_line=$(grep -n "prefer-.*= import" "$PROJECT_ROOT/flake.nix" | tail -1 | cut -d: -f1)
                ;;
            eject*)
                insert_line=$(grep -n "eject-.*= import" "$PROJECT_ROOT/flake.nix" | tail -1 | cut -d: -f1)
                ;;
            force*)
                insert_line=$(grep -n "force-.*= import" "$PROJECT_ROOT/flake.nix" | tail -1 | cut -d: -f1)
                ;;
            block*)
                insert_line=$(grep -n "block-.*= import" "$PROJECT_ROOT/flake.nix" | tail -1 | cut -d: -f1)
                ;;
        esac
        
        if [[ -n "$insert_line" ]]; then
            sed -i "${insert_line}a\\        ${governance_type}-${tool} = import ./nix/${governance_type}-${tool}.nix { inherit pkgs; };" "$PROJECT_ROOT/flake.nix"
        fi
    fi
    
    # Add to packages section
    if ! grep -q "inherit ${governance_type}-${tool}" "$PROJECT_ROOT/flake.nix"; then
        local insert_line
        case "$governance_type" in
            prefer*)
                insert_line=$(grep -n "inherit prefer-" "$PROJECT_ROOT/flake.nix" | tail -1 | cut -d: -f1)
                ;;
            eject*)
                insert_line=$(grep -n "inherit eject-" "$PROJECT_ROOT/flake.nix" | tail -1 | cut -d: -f1)
                ;;
            force*)
                insert_line=$(grep -n "inherit force-" "$PROJECT_ROOT/flake.nix" | tail -1 | cut -d: -f1)
                ;;
            block*)
                insert_line=$(grep -n "inherit block-" "$PROJECT_ROOT/flake.nix" | tail -1 | cut -d: -f1)
                ;;
        esac
        
        if [[ -n "$insert_line" ]]; then
            sed -i "${insert_line}a\\          inherit ${governance_type}-${tool};" "$PROJECT_ROOT/flake.nix"
        fi
    fi
    
    log_success "Updated flake.nix for ${governance_type}-${tool}"
}

# Generate tests for package
generate_tests() {
    local tool="$1"
    
    # Add to unified test framework
    if ! grep -q "test_package_family \"$tool\"" "$PROJECT_ROOT/scripts/test-governance-unified.sh"; then
        # Find the right place to add the test family
        local insert_line=$(grep -n "test_package_family" "$PROJECT_ROOT/scripts/test-governance-unified.sh" | tail -1 | cut -d: -f1)
        sed -i "${insert_line}a\\            test_package_family \"$tool\"" "$PROJECT_ROOT/scripts/test-governance-unified.sh"
    fi
    
    log_success "Added tests for $tool"
}

# Generate complete governance suite for a tool
generate_governance_suite() {
    local tool="$1"
    
    log_info "Generating complete governance suite for $tool..."
    
    for governance_type in "${GOVERNANCE_TYPES[@]}"; do
        log_info "Creating $governance_type packages for $tool..."
        
        # Create wrapper script
        create_wrapper "$tool" "$governance_type"
        
        # Create Nix derivation
        create_nix_derivation "$tool" "$governance_type"
        
        # Update flake.nix
        update_flake "$tool" "$governance_type"
    done
    
    # Generate tests
    generate_tests "$tool"
    
    # Add files to git
    git add "wrappers/${tool}."*.sh "nix/"*-${tool}.nix flake.nix "scripts/test-governance-unified.sh"
    
    log_success "Complete governance suite generated for $tool"
}

# Generate ecosystem packages
generate_ecosystem_packages() {
    local tool="$1"
    
    log_info "Generating ecosystem packages for $tool..."
    
    # This would call the existing packaging generators
    # For now, just indicate where this would happen
    for ecosystem in "${ECOSYSTEMS[@]}"; do
        log_info "Would generate $ecosystem package for $tool governance suite"
        # TODO: Call appropriate generator scripts
    done
}

# Update documentation
update_documentation() {
    local tool="$1"
    local category="${TOOL_CONFIGS[$tool]}"
    local preferred="${PREFERRED_ALTERNATIVES[$tool]}"
    
    log_info "Updating documentation for $tool..."
    
    # This would update AGENTS.md with the new package information
    # For now, just indicate what needs to be updated
    log_info "Would update AGENTS.md with $tool governance packages"
    log_info "Would update package counts in documentation"
}

# Main function
main() {
    local tool="${1:-}"
    local action="${2:-suite}"
    
    if [[ -z "$tool" ]]; then
        echo "Usage: $0 <tool> [action]"
        echo "Tools: npm pnpm yarn bun pip grep ag git-grep ucg pt sift"
        echo "Actions: suite, ecosystem, docs, all"
        exit 1
    fi
    
    # Check if tool is valid
    local valid_tools="npm pnpm yarn bun pip grep ag git-grep ucg pt sift"
    if [[ " $valid_tools " != *" $tool "* ]]; then
        echo "Unknown tool: $tool"
        echo "Available tools: npm pnpm yarn bun pip grep ag git-grep ucg pt sift"
        exit 1
    fi
    
    # Set preferred alternative based on tool
    local preferred=""
    case "$tool" in
        npm|pnpm|yarn|bun) preferred="pnpm" ;;
        pip) preferred="uv" ;;
        grep|ag|git-grep|ucg|pt|sift) preferred="ripgrep" ;;
    esac
    
    case "$action" in
        suite)
            generate_governance_suite "$tool"
            ;;
        ecosystem)
            generate_ecosystem_packages "$tool"
            ;;
        docs)
            update_documentation "$tool"
            ;;
        all)
            generate_governance_suite "$tool"
            generate_ecosystem_packages "$tool"
            update_documentation "$tool"
            ;;
        *)
            echo "Unknown action: $action"
            echo "Available actions: suite, ecosystem, docs, all"
            exit 1
            ;;
    esac
    
    log_success "Generation complete for $tool ($action)"
}

# Run main function
main "$@"
