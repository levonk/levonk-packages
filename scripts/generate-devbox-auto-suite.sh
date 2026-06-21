#!/bin/bash
set -euo pipefail

# Automated Devbox Auto-Wrapper Package Generator
# Creates complete devbox-auto wrapper suites: individual wrappers + Nix derivations + bundle packages

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

# Devbox auto command configuration
# Format: "tool"
DEVBOX_AUTO_COMMANDS=(
    "npm"
    "pnpm"
    "yarn"
    "python"
    "pip"
    "cargo"
    "rustc"
    "go"
)

# Create wrapper script
create_wrapper() {
    local tool="$1"
    
    local wrapper_file="$PROJECT_ROOT/wrappers/devbox-auto-tools/${tool}.devbox-auto.sh"
    
    cat > "$wrapper_file" << EOF
#!/usr/bin/env sh
# Devbox auto-wrapper for ${tool}
# Automatically ensures ${tool} is available via devbox before execution

SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
if [ -f "\$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "\$SCRIPT_DIR/utils/devbox-manager.sh"
fi

devbox_wrap ${tool} "\$@"
EOF
    
    chmod +x "$wrapper_file"
    log_success "Created wrapper: $wrapper_file"
}

# Create Nix derivation
create_nix_derivation() {
    local tool="$1"
    
    local nix_file="$PROJECT_ROOT/nix/devbox-auto-${tool}.nix"
    
    cat > "$nix_file" << EOF
{ pkgs }:

pkgs.writeShellScriptBin "${tool}" ''
  #!/usr/bin/env sh
  \${builtins.readFile ../wrappers/devbox-auto-tools/${tool}.devbox-auto.sh}
''
EOF
    
    log_success "Created Nix derivation: $nix_file"
}

# Update flake.nix
update_flake() {
    local tool="$1"
    
    # Add to imports section
    if ! grep -q "devbox-auto-${tool} = import" "$PROJECT_ROOT/flake.nix"; then
        # Find the line with other devbox-auto imports
        local insert_line=$(grep -n "devbox-auto-.*= import" "$PROJECT_ROOT/flake.nix" | tail -1 | cut -d: -f1)
        
        if [[ -n "$insert_line" ]]; then
            sed -i "${insert_line}a\\        devbox-auto-${tool} = import ./nix/devbox-auto-${tool}.nix { inherit pkgs; };" "$PROJECT_ROOT/flake.nix"
        fi
    fi
    
    # Add to packages section
    if ! grep -q "inherit devbox-auto-${tool}" "$PROJECT_ROOT/flake.nix"; then
        local insert_line=$(grep -n "inherit devbox-auto-" "$PROJECT_ROOT/flake.nix" | tail -1 | cut -d: -f1)
        
        if [[ -n "$insert_line" ]]; then
            sed -i "${insert_line}a\\          inherit devbox-auto-${tool};" "$PROJECT_ROOT/flake.nix"
        fi
    fi
    
    log_success "Updated flake.nix for devbox-auto-${tool}"
}

# Generate complete devbox-auto suite
generate_devbox_auto_suite() {
    log_info "Generating complete devbox-auto wrapper suite..."
    
    for tool in "${DEVBOX_AUTO_COMMANDS[@]}"; do
        log_info "Processing $tool..."
        
        # Create wrapper script
        create_wrapper "$tool"
        
        # Create Nix derivation
        create_nix_derivation "$tool"
        
        # Update flake.nix
        update_flake "$tool"
    done
    
    # Add files to git
    git add "wrappers/devbox-auto-tools/"*.sh "nix/devbox-auto-"*.nix flake.nix
    
    log_success "Complete devbox-auto wrapper suite generated"
}

# Main function
main() {
    local action="${1:-suite}"
    
    case "$action" in
        suite)
            generate_devbox_auto_suite
            ;;
        wrappers)
            for tool in "${DEVBOX_AUTO_COMMANDS[@]}"; do
                create_wrapper "$tool"
            done
            ;;
        nix)
            for tool in "${DEVBOX_AUTO_COMMANDS[@]}"; do
                create_nix_derivation "$tool"
            done
            ;;
        flake)
            for tool in "${DEVBOX_AUTO_COMMANDS[@]}"; do
                update_flake "$tool"
            done
            ;;
        *)
            echo "Usage: $0 [suite|wrappers|nix|flake]"
            echo "  suite    - Generate complete devbox-auto suite (default)"
            echo "  wrappers - Generate wrapper scripts only"
            echo "  nix      - Generate Nix derivations only"
            echo "  flake    - Update flake.nix only"
            exit 1
            ;;
    esac
}

main "$@"