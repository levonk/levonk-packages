#!/bin/bash
set -euo pipefail

# Generate flake.nix with all packages

cat > flake.nix << 'EOF'
{
  description = "Command Preference & Package Governance System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
EOF

# Add all package imports
echo "        # Import all packages" >> flake.nix

# npm governance packages
echo "        prefer-pnpm = import ./nix/prefer-pnpm.nix { inherit pkgs; };" >> flake.nix
echo "        eject-npm = import ./nix/eject-npm.nix { inherit pkgs; };" >> flake.nix
echo "        force-pnpm = import ./nix/force-pnpm.nix { inherit pkgs; };" >> flake.nix
echo "        block-npm = import ./nix/block-npm.nix { inherit pkgs; };" >> flake.nix
echo "        prefer-yarn = import ./nix/prefer-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        eject-yarn = import ./nix/eject-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        force-yarn = import ./nix/force-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        block-yarn = import ./nix/block-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        prefer-bun = import ./nix/prefer-bun.nix { inherit pkgs; };" >> flake.nix
echo "        eject-bun = import ./nix/eject-bun.nix { inherit pkgs; };" >> flake.nix
echo "        force-bun = import ./nix/force-bun.nix { inherit pkgs; };" >> flake.nix
echo "        block-bun = import ./nix/block-bun.nix { inherit pkgs; };" >> flake.nix

# pip governance packages
echo "        prefer-uv = import ./nix/prefer-uv.nix { inherit pkgs; };" >> flake.nix
echo "        block-pip = import ./nix/block-pip.nix { inherit pkgs; };" >> flake.nix
echo "        eject-pip = import ./nix/eject-pip.nix { inherit pkgs; };" >> flake.nix
echo "        force-uv = import ./nix/force-uv.nix { inherit pkgs; };" >> flake.nix
echo "        prefer-npm = import ./nix/prefer-npm.nix { inherit pkgs; };" >> flake.nix
echo "        force-npm = import ./nix/force-npm.nix { inherit pkgs; };" >> flake.nix
echo "        eject-pnpm = import ./nix/eject-pnpm.nix { inherit pkgs; };" >> flake.nix
echo "        block-pnpm = import ./nix/block-pnpm.nix { inherit pkgs; };" >> flake.nix
echo "        prefer-yarn-from-pnpm = import ./nix/prefer-yarn-from-pnpm.nix { inherit pkgs; };" >> flake.nix
echo "        force-yarn-from-pnpm = import ./nix/force-yarn-from-pnpm.nix { inherit pkgs; };" >> flake.nix
echo "        block-yarn-from-pnpm = import ./nix/block-yarn-from-pnpm.nix { inherit pkgs; };" >> flake.nix
echo "        eject-yarn-from-pnpm = import ./nix/eject-yarn-from-pnpm.nix { inherit pkgs; };" >> flake.nix
echo "        prefer-bun-from-pnpm = import ./nix/prefer-bun-from-pnpm.nix { inherit pkgs; };" >> flake.nix
echo "        force-bun-from-pnpm = import ./nix/force-bun-from-pnpm.nix { inherit pkgs; };" >> flake.nix
echo "        block-bun-from-pnpm = import ./nix/block-bun-from-pnpm.nix { inherit pkgs; };" >> flake.nix
echo "        eject-bun-from-pnpm = import ./nix/eject-bun-from-pnpm.nix { inherit pkgs; };" >> flake.nix

# yarn governance packages
echo "        prefer-npm-from-yarn = import ./nix/prefer-npm-from-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        force-npm-from-yarn = import ./nix/force-npm-from-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        block-npm-from-yarn = import ./nix/block-npm-from-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        eject-npm-from-yarn = import ./nix/eject-npm-from-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        prefer-pnpm-from-yarn = import ./nix/prefer-pnpm-from-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        force-pnpm-from-yarn = import ./nix/force-pnpm-from-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        block-pnpm-from-yarn = import ./nix/block-pnpm-from-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        eject-pnpm-from-yarn = import ./nix/eject-pnpm-from-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        prefer-bun-from-yarn = import ./nix/prefer-bun-from-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        force-bun-from-yarn = import ./nix/force-bun-from-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        block-bun-from-yarn = import ./nix/block-bun-from-yarn.nix { inherit pkgs; };" >> flake.nix
echo "        eject-bun-from-yarn = import ./nix/eject-bun-from-yarn.nix { inherit pkgs; };" >> flake.nix

# bun governance packages
echo "        prefer-npm-from-bun = import ./nix/prefer-npm-from-bun.nix { inherit pkgs; };" >> flake.nix
echo "        force-npm-from-bun = import ./nix/force-npm-from-bun.nix { inherit pkgs; };" >> flake.nix
echo "        block-npm-from-bun = import ./nix/block-npm-from-bun.nix { inherit pkgs; };" >> flake.nix
echo "        eject-npm-from-bun = import ./nix/eject-npm-from-bun.nix { inherit pkgs; };" >> flake.nix
echo "        prefer-pnpm-from-bun = import ./nix/prefer-pnpm-from-bun.nix { inherit pkgs; };" >> flake.nix
echo "        force-pnpm-from-bun = import ./nix/force-pnpm-from-bun.nix { inherit pkgs; };" >> flake.nix
echo "        block-pnpm-from-bun = import ./nix/block-pnpm-from-bun.nix { inherit pkgs; };" >> flake.nix
echo "        eject-pnpm-from-bun = import ./nix/eject-pnpm-from-bun.nix { inherit pkgs; };" >> flake.nix
echo "        prefer-yarn-from-bun = import ./nix/prefer-yarn-from-bun.nix { inherit pkgs; };" >> flake.nix
echo "        force-yarn-from-bun = import ./nix/force-yarn-from-bun.nix { inherit pkgs; };" >> flake.nix
echo "        block-yarn-from-bun = import ./nix/block-yarn-from-bun.nix { inherit pkgs; };" >> flake.nix
echo "        eject-yarn-from-bun = import ./nix/eject-yarn-from-bun.nix { inherit pkgs; };" >> flake.nix

# Other packages
echo "        prefer-devbox = import ./nix/prefer-devbox.nix { inherit pkgs; };" >> flake.nix
echo "        prefer-corepack = import ./nix/prefer-corepack.nix { inherit pkgs; };" >> flake.nix

# Bundle package
cat >> flake.nix << 'EOF'
        
        # Bundle package
        command-governance = import ./nix/bundle-command-governance.nix { inherit pkgs; };
        
      in
      {
        packages = {
EOF

# Add all packages to packages section
echo "          # npm governance packages" >> flake.nix
echo "          inherit prefer-pnpm;" >> flake.nix
echo "          inherit eject-npm;" >> flake.nix
echo "          inherit force-pnpm;" >> flake.nix
echo "          inherit block-npm;" >> flake.nix
echo "          inherit prefer-yarn;" >> flake.nix
echo "          inherit eject-yarn;" >> flake.nix
echo "          inherit force-yarn;" >> flake.nix
echo "          inherit block-yarn;" >> flake.nix
echo "          inherit prefer-bun;" >> flake.nix
echo "          inherit eject-bun;" >> flake.nix
echo "          inherit force-bun;" >> flake.nix
echo "          inherit block-bun;" >> flake.nix

echo "          # pnpm governance packages" >> flake.nix
echo "          inherit prefer-uv;" >> flake.nix
echo "          inherit eject-pip;" >> flake.nix
echo "          inherit block-pip;" >> flake.nix
echo "          inherit prefer-npm;" >> flake.nix
echo "          inherit force-npm;" >> flake.nix
echo "          inherit eject-pnpm;" >> flake.nix
echo "          inherit block-pnpm;" >> flake.nix
echo "          inherit prefer-yarn-from-pnpm;" >> flake.nix
echo "          inherit force-yarn-from-pnpm;" >> flake.nix
echo "          inherit block-yarn-from-pnpm;" >> flake.nix
echo "          inherit eject-yarn-from-pnpm;" >> flake.nix
echo "          inherit prefer-bun-from-pnpm;" >> flake.nix
echo "          inherit force-bun-from-pnpm;" >> flake.nix
echo "          inherit block-bun-from-pnpm;" >> flake.nix
echo "          inherit eject-bun-from-pnpm;" >> flake.nix

echo "          # yarn governance packages" >> flake.nix
echo "          inherit prefer-npm-from-yarn;" >> flake.nix
echo "          inherit force-npm-from-yarn;" >> flake.nix
echo "          inherit block-npm-from-yarn;" >> flake.nix
echo "          inherit eject-npm-from-yarn;" >> flake.nix
echo "          inherit prefer-pnpm-from-yarn;" >> flake.nix
echo "          inherit force-pnpm-from-yarn;" >> flake.nix
echo "          inherit block-pnpm-from-yarn;" >> flake.nix
echo "          inherit eject-pnpm-from-yarn;" >> flake.nix
echo "          inherit prefer-bun-from-yarn;" >> flake.nix
echo "          inherit force-bun-from-yarn;" >> flake.nix
echo "          inherit block-bun-from-yarn;" >> flake.nix
echo "          inherit eject-bun-from-yarn;" >> flake.nix

echo "          # bun governance packages" >> flake.nix
echo "          inherit prefer-npm-from-bun;" >> flake.nix
echo "          inherit force-npm-from-bun;" >> flake.nix
echo "          inherit block-npm-from-bun;" >> flake.nix
echo "          inherit eject-npm-from-bun;" >> flake.nix
echo "          inherit prefer-pnpm-from-bun;" >> flake.nix
echo "          inherit force-pnpm-from-bun;" >> flake.nix
echo "          inherit block-pnpm-from-bun;" >> flake.nix
echo "          inherit eject-pnpm-from-bun;" >> flake.nix
echo "          inherit prefer-yarn-from-bun;" >> flake.nix
echo "          inherit force-yarn-from-bun;" >> flake.nix
echo "          inherit block-yarn-from-bun;" >> flake.nix
echo "          inherit eject-yarn-from-bun;" >> flake.nix

echo "          # Other packages" >> flake.nix
echo "          inherit prefer-devbox;" >> flake.nix
echo "          inherit prefer-corepack;" >> flake.nix
echo "          inherit force-uv;" >> flake.nix

# Logical bundle packages
echo "          nodejs-ecosystem = import ./nix/nodejs-ecosystem.nix { inherit pkgs; };" >> flake.nix
echo "          python-ecosystem = import ./nix/python-ecosystem.nix { inherit pkgs; };" >> flake.nix
echo "          dev-tools = import ./nix/dev-tools.nix { inherit pkgs; };" >> flake.nix
echo "          migrate-to-pnpm-bundle = import ./nix/migrate-to-pnpm-bundle.nix { inherit pkgs; };" >> flake.nix
echo "          migrate-to-uv-bundle = import ./nix/migrate-to-uv-bundle.nix { inherit pkgs; };" >> flake.nix

echo "          inherit force-devbox;" >> flake.nix
echo "          inherit command-governance;" >> flake.nix

cat >> flake.nix << 'EOF'
          
          # Default package
          default = command-governance;
        };
        
        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            just
            nix
            devbox
          ];
        };
      });
}
EOF

echo "Generated flake.nix with all packages!"
