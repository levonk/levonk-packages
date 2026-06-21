#!/bin/bash
set -euo pipefail

# Automated Devbox-RTK-Governance Package Generator
# Creates integrated packages: devbox environment management + RTK token optimization + tool governance

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

# Ecosystem configuration
# Format: "ecosystem:preferred-tool:tools-to-govern"
ECOSYSTEMS=(
    "nodejs:pnpm:npm"
    "nodejs:yarn:npm,pnpm"
    "nodejs:bun:npm,pnpm,yarn"
    "python:uv:pip"
)

# Governance types
GOVERNANCE_TYPES=("prefer" "force" "block" "native")

# Create integrated wrapper script
create_integrated_wrapper() {
    local ecosystem="$1"
    local preferred_tool="$2"
    local tools_to_govern="$3"
    local governance_type="$4"
    
    local wrapper_file="$PROJECT_ROOT/wrappers/devbox-rtk-tools/${ecosystem}-${preferred_tool}-${governance_type}.sh"
    
    # Generate governance logic based on type
    local governance_logic=""
    case "$governance_type" in
        prefer)
            governance_logic="echo \"⚠️ Prefer $preferred_tool over $(basename "$0"). Using $preferred_tool...\""
            ;;
        force)
            governance_logic="echo \"✅ Using $preferred_tool instead of $(basename "$0") (forced by policy)...\""
            ;;
        block)
            governance_logic="echo \"❌ $(basename "$0") is blocked by policy. Use $preferred_tool instead.\"
            case "$ecosystem" in
                nodejs)
                    governance_logic="$governance_logic"
                    governance_logic="$governance_logic"
                    case "$preferred_tool" in
                        pnpm) governance_logic="$governance_logic"
                               governance_logic="$governance_logic"
                               echo "💡 Install pnpm: https://pnpm.io/installation" ;;
                        yarn) governance_logic="$governance_logic"
                               governance_logic="$governance_logic"
                               echo "💡 Install yarn: https://yarnpkg.com/getting-started/install" ;;
                        bun)  governance_logic="$governance_logic"
                               governance_logic="$governance_logic"
                               echo "💡 Install bun: https://bun.sh/docs/installation" ;;
                    esac
                    ;;
                python)
                    governance_logic="$governance_logic"
                    echo "💡 Install uv: https://github.com/astral-sh/uv"
                    ;;
            esac
            governance_logic="$governance_logic"
            echo "exit 1"
            ;;
        native)
            governance_logic="# No governance - use tools as-is"
            ;;
    esac
    
    cat > "$wrapper_file" << EOF
#!/usr/bin/env sh
# Integrated devbox + RTK + governance wrapper for ${ecosystem^} with ${preferred_tool} ${governance_type}
# Combines: environment management (devbox) + token optimization (RTK) + tool governance (${governance_type})

SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
if [ -f "\$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
    . "\$SCRIPT_DIR/utils/devbox-manager.sh"
fi
if [ -f "\$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "\$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

# Governance: ${governance_type^} ${tools_to_govern} → ${preferred_tool}
if [ "$governance_type" != "native" ]; then
    case "\$(basename "\$0")" in
        $(echo "$tools_to_govern" | sed 's/,/|/g'))
            $governance_logic
            set -- ${preferred_tool} "\$@"
            ;;
    esac
fi

# Environment management + RTK optimization for ${preferred_tool}
devbox_wrap ${preferred_tool} "\$@"
EOF
    
    chmod +x "$wrapper_file"
    log_success "Created wrapper: $wrapper_file"
}

# Create integrated Nix derivation
create_integrated_nix() {
    local ecosystem="$1"
    local preferred_tool="$2"
    local tools_to_govern="$3"
    local governance_type="$4"
    
    local nix_file="$PROJECT_ROOT/nix/devbox-rtk-${ecosystem}-${preferred_tool}-${governance_type}.nix"
    
    # Generate wrapper declarations
    local wrapper_declarations=""
    local tool_array=($(echo "$tools_to_govern" | tr ',' ' '))
    for tool in "${tool_array[@]}"; do
        wrapper_declarations="$wrapper_declarations
  # Create ${tool} wrapper
  ${tool}-wrapper = pkgs.writeShellScriptBin \"${tool}\" ''
    #!/usr/bin/env sh
    \${builtins.readFile ../wrappers/devbox-rtk-tools/${ecosystem}-${preferred_tool}-${governance_type}.sh}
  '';"
    done
    
    # Add preferred tool wrapper
    wrapper_declarations="$wrapper_declarations
  # Create ${preferred_tool} wrapper
  ${preferred_tool}-wrapper = pkgs.writeShellScriptBin \"${preferred_tool}\" ''
    #!/usr/bin/env sh
    SCRIPT_DIR=\"\$(cd \"\$(dirname \"\${BASH_SOURCE[0]}\")\" && pwd)\"
    if [ -f \"\$SCRIPT_DIR/utils/devbox-manager.sh\" ]; then
        . \"\$SCRIPT_DIR/utils/devbox-manager.sh\"
    fi
    if [ -f \"\$SCRIPT_DIR/utils/rtk-wrapper.sh\" ]; then
        . \"\$SCRIPT_DIR/utils/rtk-wrapper.sh\"
    fi
    devbox_wrap ${preferred_tool} \"\$@\"
  '';"
    
    # Generate paths array
    local paths_array="paths = ["
    for tool in "${tool_array[@]}"; do
        paths_array="$paths_array
    ${tool}-wrapper"
"
    done
    paths_array="$paths_array
    ${preferred_tool}-wrapper
  ];"
    
    cat > "$nix_file" << EOF
{ pkgs }:

let
$wrapper_declarations
in
pkgs.symlinkJoin {
  name = "devbox-rtk-${ecosystem}-${preferred_tool}-${governance_type}";
  $paths_array
}
EOF
    
    log_success "Created Nix derivation: $nix_file"
}

# Update flake.nix
update_flake() {
    local ecosystem="$1"
    local preferred_tool="$2"
    local governance_type="$3"
    local package_name="devbox-rtk-${ecosystem}-${preferred_tool}-${governance_type}"
    
    # Add to imports section
    if ! grep -q "${package_name} = import" "$PROJECT_ROOT/flake.nix"; then
        local insert_line=$(grep -n "devbox-rtk-.*= import" "$PROJECT_ROOT/flake.nix" | tail -1 | cut -d: -f1)
        
        if [[ -n "$insert_line" ]]; then
            sed -i "${insert_line}a\\        ${package_name} = import ./nix/${package_name}.nix { inherit pkgs; };" "$PROJECT_ROOT/flake.nix"
        fi
    fi
    
    # Add to packages section
    if ! grep -q "inherit ${package_name}" "$PROJECT_ROOT/flake.nix"; then
        local insert_line=$(grep -n "inherit devbox-rtk-" "$PROJECT_ROOT/flake.nix" | tail -1 | cut -d: -f1)
        
        if [[ -n "$insert_line" ]]; then
            sed -i "${insert_line}a\\          inherit ${package_name};" "$PROJECT_ROOT/flake.nix"
        fi
    fi
    
    log_success "Updated flake.nix for ${package_name}"
}

# Generate complete integrated suite
generate_integrated_suite() {
    local ecosystem="$1"
    
    log_info "Generating complete devbox-rtk suite for $ecosystem..."
    
    for ecosystem_config in "${ECOSYSTEMS[@]}"; do
        IFS=':' read -r config_ecosystem preferred_tool tools_to_govern <<< "$ecosystem_config"
        
        if [[ "$config_ecosystem" == "$ecosystem" ]]; then
            for governance_type in "${GOVERNANCE_TYPES[@]}"; do
                log_info "Creating $governance_type package for $ecosystem with $preferred_tool..."
                
                create_integrated_wrapper "$ecosystem" "$preferred_tool" "$tools_to_govern" "$governance_type"
                create_integrated_nix "$ecosystem" "$preferred_tool" "$tools_to_govern" "$governance_type"
                update_flake "$ecosystem" "$preferred_tool" "$governance_type"
            done
        fi
    done
    
    # Add files to git
    git add "wrappers/devbox-rtk-tools/${ecosystem}-"*" "nix/devbox-rtk-${ecosystem}-"* flake.nix
    
    log_success "Complete devbox-rtk suite generated for $ecosystem"
}

# Main function
main() {
    local ecosystem="${1:-all}"
    local action="${2:-suite}"
    
    case "$action" in
        suite)
            if [[ "$ecosystem" == "all" ]]; then
                for ecosystem_config in "${ECOSYSTEMS[@]}"; do
                    IFS=':' read -r config_ecosystem preferred_tool tools_to_govern <<< "$ecosystem_config"
                    generate_integrated_suite "$config_ecosystem"
                done
            else
                generate_integrated_suite "$ecosystem"
            fi
            ;;
        *)
            echo "Usage: $0 [ecosystem] [suite]"
            echo "Ecosystems: nodejs, python, all"
            echo "Actions: suite (default)"
            exit 1
            ;;
    esac
}

main "$@"