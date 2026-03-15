#!/bin/bash
set -euo pipefail

# Update bundle packages and create new force bundles

echo "🔄 Updating bundle packages..."

# Create prefer-all bundle
cat > nix/prefer-all.nix << 'EOF'
{ pkgs }:

let
  # Import all prefer packages
  prefer-pnpm = import ./prefer-pnpm.nix { inherit pkgs; };
  prefer-yarn = import ./prefer-yarn.nix { inherit pkgs; };
  prefer-bun = import ./prefer-bun.nix { inherit pkgs; };
  prefer-uv = import ./prefer-uv.nix { inherit pkgs; };
  prefer-npm = import ./prefer-npm.nix { inherit pkgs; };
  prefer-yarn-from-pnpm = import ./prefer-yarn-from-pnpm.nix { inherit pkgs; };
  prefer-bun-from-pnpm = import ./prefer-bun-from-pnpm.nix { inherit pkgs; };
  prefer-npm-from-yarn = import ./prefer-npm-from-yarn.nix { inherit pkgs; };
  prefer-pnpm-from-yarn = import ./prefer-pnpm-from-yarn.nix { inherit pkgs; };
  prefer-bun-from-yarn = import ./prefer-bun-from-yarn.nix { inherit pkgs; };
  prefer-npm-from-bun = import ./prefer-npm-from-bun.nix { inherit pkgs; };
  prefer-pnpm-from-bun = import ./prefer-pnpm-from-bun.nix { inherit pkgs; };
  prefer-yarn-from-bun = import ./prefer-yarn-from-bun.nix { inherit pkgs; };
  prefer-devbox = import ./prefer-devbox.nix { inherit pkgs; };
  prefer-corepack = import ./prefer-corepack.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "prefer-all";
  paths = [
    prefer-pnpm
    prefer-yarn
    prefer-bun
    prefer-uv
    prefer-npm
    prefer-yarn-from-pnpm
    prefer-bun-from-pnpm
    prefer-npm-from-yarn
    prefer-pnpm-from-yarn
    prefer-bun-from-yarn
    prefer-npm-from-bun
    prefer-pnpm-from-bun
    prefer-yarn-from-bun
    prefer-devbox
    prefer-corepack
  ];
}
EOF

# Create force-pnpm bundle
cat > nix/force-pnpm.nix << 'EOF'
{ pkgs }:

let
  # Import force packages that replace with pnpm
  force-pnpm = import ./force-pnpm.nix { inherit pkgs; };
  force-yarn-from-pnpm = import ./force-yarn-from-pnpm.nix { inherit pkgs; };
  force-bun-from-pnpm = import ./force-bun-from-pnpm.nix { inherit pkgs; };
  
  # Import eject packages (dependencies)
  eject-npm = import ./eject-npm.nix { inherit pkgs; };
  eject-yarn-from-pnpm = import ./eject-yarn-from-pnpm.nix { inherit pkgs; };
  eject-bun-from-pnpm = import ./eject-bun-from-pnpm.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "force-pnpm";
  paths = [
    force-pnpm
    force-yarn-from-pnpm
    force-bun-from-pnpm
    eject-npm
    eject-yarn-from-pnpm
    eject-bun-from-pnpm
  ];
}
EOF

# Create force-uv bundle
cat > nix/force-uv-bundle.nix << 'EOF'
{ pkgs }:

let
  # Import force package for uv
  force-uv = import ./force-uv.nix { inherit pkgs; };
  
  # Import eject package (dependency)
  eject-pip = import ./eject-pip.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "force-uv";
  paths = [
    force-uv
    eject-pip
  ];
}
EOF

# Create force-devbox bundle
cat > nix/force-devbox-bundle.nix << 'EOF'
{ pkgs }:

let
  # Import force package for devbox
  force-devbox = import ./force-devbox.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "force-devbox";
  paths = [
    force-devbox
  ];
}
EOF

echo "✅ Created new bundle packages:"
echo "  - prefer-all (all prefer packages)"
echo "  - force-pnpm (all pnpm force packages)"
echo "  - force-uv (uv force package)"
echo "  - force-devbox (devbox force package)"
