#!/bin/bash
set -euo pipefail

# Generate Nix derivations for yarn and bun governance packages

generate_nix_package() {
    local target_bin="$1"
    local preferred_tool="$2"
    local behavior="$3"
    local package_name="$4"
    local pkgs_tool="$5"
    
    local nix_file="nix/${package_name}.nix"
    
    case "$behavior" in
        prefer)
            cat > "$nix_file" << EOF
{ pkgs }:

let
  ${pkgs_tool} = pkgs.${pkgs_tool};
in
pkgs.writeShellScriptBin "$target_bin" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer ${preferred_tool} over ${target_bin}. Running ${preferred_tool} instead..."
  exec \${${pkgs_tool}}/bin/${preferred_tool} "\$@"
''
EOF
            ;;
        force)
            cat > "$nix_file" << EOF
{ pkgs }:

let
  ${pkgs_tool} = pkgs.${pkgs_tool};
in
pkgs.writeShellScriptBin "$target_bin" ''
  #!/usr/bin/env sh
  echo "✅ Using ${preferred_tool} instead of ${target_bin} (forced by policy)..."
  exec \${${pkgs_tool}}/bin/${preferred_tool} "\$@"
''
EOF
            ;;
        block)
            cat > "$nix_file" << EOF
{ pkgs }:

pkgs.writeShellScriptBin "$target_bin" ''
  #!/usr/bin/env sh
  echo "❌ ${target_bin} is blocked by policy. Use ${preferred_tool} instead."
  exit 1
''
EOF
            ;;
        eject)
            cat > "$nix_file" << EOF
{ pkgs }:

pkgs.writeShellScriptBin "$target_bin" ''
  #!/usr/bin/env sh
  echo "❌ ${target_bin} has been ejected by policy."
  echo "${target_bin} has been removed and future installs are blocked."
  echo "Use ${preferred_tool} instead."
  exit 1
''
EOF
            ;;
    esac
    
    echo "Generated $nix_file"
}

# yarn governance packages
echo "Generating yarn governance packages..."
generate_nix_package "yarn" "npm" "prefer" "prefer-npm-from-yarn" "nodePackages.npm"
generate_nix_package "yarn" "npm" "force" "force-npm-from-yarn" "nodePackages.npm"
generate_nix_package "yarn" "npm" "block" "block-npm-from-yarn" "nodePackages.npm"
generate_nix_package "yarn" "npm" "eject" "eject-npm-from-yarn" "nodePackages.npm"

generate_nix_package "yarn" "pnpm" "prefer" "prefer-pnpm-from-yarn" "pnpm"
generate_nix_package "yarn" "pnpm" "force" "force-pnpm-from-yarn" "pnpm"
generate_nix_package "yarn" "pnpm" "block" "block-pnpm-from-yarn" "pnpm"
generate_nix_package "yarn" "pnpm" "eject" "eject-pnpm-from-yarn" "pnpm"

generate_nix_package "yarn" "bun" "prefer" "prefer-bun-from-yarn" "bun"
generate_nix_package "yarn" "bun" "force" "force-bun-from-yarn" "bun"
generate_nix_package "yarn" "bun" "block" "block-bun-from-yarn" "bun"
generate_nix_package "yarn" "bun" "eject" "eject-bun-from-yarn" "bun"

# bun governance packages
echo "Generating bun governance packages..."
generate_nix_package "bun" "npm" "prefer" "prefer-npm-from-bun" "nodePackages.npm"
generate_nix_package "bun" "npm" "force" "force-npm-from-bun" "nodePackages.npm"
generate_nix_package "bun" "npm" "block" "block-npm-from-bun" "nodePackages.npm"
generate_nix_package "bun" "npm" "eject" "eject-npm-from-bun" "nodePackages.npm"

generate_nix_package "bun" "pnpm" "prefer" "prefer-pnpm-from-bun" "pnpm"
generate_nix_package "bun" "pnpm" "force" "force-pnpm-from-bun" "pnpm"
generate_nix_package "bun" "pnpm" "block" "block-pnpm-from-bun" "pnpm"
generate_nix_package "bun" "pnpm" "eject" "eject-pnpm-from-bun" "pnpm"

generate_nix_package "bun" "yarn" "prefer" "prefer-yarn-from-bun" "yarn"
generate_nix_package "bun" "yarn" "force" "force-yarn-from-bun" "yarn"
generate_nix_package "bun" "yarn" "block" "block-yarn-from-bun" "yarn"
generate_nix_package "bun" "yarn" "eject" "eject-yarn-from-bun" "yarn"

echo "All Nix packages generated successfully!"
