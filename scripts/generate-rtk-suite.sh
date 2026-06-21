#!/bin/bash
set -euo pipefail

# Automated RTK Wrapper Package Generator
# Creates complete RTK wrapper suites: individual wrappers + Nix derivations + bundle packages

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

# RTK command configuration
# Format: "native_command:rtk_subcommand:description"
RTK_COMMANDS=(
    "ls:ls:token-optimized output"
    "tree:tree:token-optimized output"
    "git:git:token-optimized output"
    "grep:grep:compact grep output"
    "find:find:compact tree output"
    "cat:read:intelligent file filtering"
    "npm:npm:filtered output"
    "npx:npx:intelligent routing"
    "pnpm:pnpm:ultra-compact output"
    "tsc:tsc:grouped error output"
    "jest:jest:compact output"
    "vitest:vitest:compact output"
    "pytest:pytest:compact output"
    "mypy:mypy:grouped error output"
    "ruff:ruff:compact output"
    "prettier:prettier:compact output"
    "eslint:eslint:grouped rule violations"
    "prisma:prisma:compact output (no ASCII art)"
    "next:next:compact build output"
    "lint:lint:grouped rule violations"
    "format:format:universal format checker"
    "playwright:playwright:compact E2E test output"
    "gh:gh:token-optimized output"
    "glab:glab:token-optimized output"
    "diff:diff:ultra-condensed output"
    "curl:curl:auto-JSON detection and schema output"
    "wget:wget:compact output (strips progress bars)"
    "wc:wc:compact output"
    "docker:docker:compact output"
    "kubectl:kubectl:compact output"
    "oc:oc:compact OpenShift output"
    "cargo:cargo:compact output"
    "pip:pip:compact output"
    "dotnet:dotnet:compact output"
    "aws:aws:compact output (force JSON, compress)"
    "psql:psql:compact output (strip borders, compress tables)"
    "go:go:compact output"
    "gt:gt:compact stacked PR output"
    "golangci-lint:golangci-lint:compact run support"
    "rubocop:rubocop:compact output"
    "rake:rake:compact minitest output"
    "rspec:rspec:compact JSON output"
    "gradlew:gradlew:compact Android build output"
    "json:json:compact values"
    "env:env:filtered output (sensitive masked)"
    "deps:deps:summarize project dependencies"
    "test:test:show only failures"
    "err:err:show only errors/warnings"
)

# Create wrapper script
create_wrapper() {
    local native_cmd="$1"
    local rtk_subcommand="$2"
    local description="$3"
    
    local wrapper_file="$PROJECT_ROOT/wrappers/rtk-tools/${native_cmd}.rtk-wrap.sh"
    
    cat > "$wrapper_file" << EOF
#!/usr/bin/env sh
# RTK wrapper for ${native_cmd} command
# Transparently runs ${native_cmd} through RTK for ${description}

SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
if [ -f "\$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
    . "\$SCRIPT_DIR/utils/rtk-wrapper.sh"
fi

rtk_wrap ${native_cmd} ${rtk_subcommand} "${description}"
EOF
    
    chmod +x "$wrapper_file"
    log_success "Created wrapper: $wrapper_file"
}

# Create Nix derivation
create_nix_derivation() {
    local native_cmd="$1"
    
    local nix_file="$PROJECT_ROOT/nix/rtk-wrap-${native_cmd}.nix"
    
    cat > "$nix_file" << EOF
{ pkgs }:

pkgs.writeShellScriptBin "${native_cmd}" ''
  #!/usr/bin/env sh
  \${builtins.readFile ../wrappers/rtk-tools/${native_cmd}.rtk-wrap.sh}
''
EOF
    
    log_success "Created Nix derivation: $nix_file"
}

# Update flake.nix
update_flake() {
    local native_cmd="$1"
    
    # Add to imports section
    if ! grep -q "rtk-wrap-${native_cmd} = import" "$PROJECT_ROOT/flake.nix"; then
        # Find the line with other RTK imports
        local insert_line=$(grep -n "rtk-wrap-.*= import" "$PROJECT_ROOT/flake.nix" | tail -1 | cut -d: -f1)
        
        if [[ -n "$insert_line" ]]; then
            sed -i "${insert_line}a\\        rtk-wrap-${native_cmd} = import ./nix/rtk-wrap-${native_cmd}.nix { inherit pkgs; };" "$PROJECT_ROOT/flake.nix"
        fi
    fi
    
    # Add to packages section
    if ! grep -q "inherit rtk-wrap-${native_cmd}" "$PROJECT_ROOT/flake.nix"; then
        local insert_line=$(grep -n "inherit rtk-wrap-" "$PROJECT_ROOT/flake.nix" | tail -1 | cut -d: -f1)
        
        if [[ -n "$insert_line" ]]; then
            sed -i "${insert_line}a\\          inherit rtk-wrap-${native_cmd};" "$PROJECT_ROOT/flake.nix"
        fi
    fi
    
    log_success "Updated flake.nix for rtk-wrap-${native_cmd}"
}

# Generate complete RTK suite
generate_rtk_suite() {
    log_info "Generating complete RTK wrapper suite..."
    
    for cmd_config in "${RTK_COMMANDS[@]}"; do
        IFS=':' read -r native_cmd rtk_subcommand description <<< "$cmd_config"
        
        log_info "Processing $native_cmd..."
        
        # Create wrapper script
        create_wrapper "$native_cmd" "$rtk_subcommand" "$description"
        
        # Create Nix derivation
        create_nix_derivation "$native_cmd"
        
        # Update flake.nix
        update_flake "$native_cmd"
    done
    
    # Add files to git
    git add "wrappers/rtk-tools/"*.sh "nix/rtk-wrap-"*.nix flake.nix
    
    log_success "Complete RTK wrapper suite generated"
}

# Main function
main() {
    local action="${1:-suite}"
    
    case "$action" in
        suite)
            generate_rtk_suite
            ;;
        wrappers)
            for cmd_config in "${RTK_COMMANDS[@]}"; do
                IFS=':' read -r native_cmd rtk_subcommand description <<< "$cmd_config"
                create_wrapper "$native_cmd" "$rtk_subcommand" "$description"
            done
            ;;
        nix)
            for cmd_config in "${RTK_COMMANDS[@]}"; do
                IFS=':' read -r native_cmd rtk_subcommand description <<< "$cmd_config"
                create_nix_derivation "$native_cmd"
            done
            ;;
        flake)
            for cmd_config in "${RTK_COMMANDS[@]}"; do
                IFS=':' read -r native_cmd rtk_subcommand description <<< "$cmd_config"
                update_flake "$native_cmd"
            done
            ;;
        *)
            echo "Usage: $0 [suite|wrappers|nix|flake]"
            echo "  suite    - Generate complete RTK wrapper suite (default)"
            echo "  wrappers - Generate wrapper scripts only"
            echo "  nix      - Generate Nix derivations only"
            echo "  flake    - Update flake.nix only"
            exit 1
            ;;
    esac
}

main "$@"