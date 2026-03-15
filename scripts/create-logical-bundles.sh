#!/bin/bash
set -euo pipefail

# Create logical bundles based on tool categories

echo "🔄 Creating logical bundles based on tool categories..."

# Create Node.js ecosystem bundle
cat > nix/nodejs-ecosystem.nix << 'EOF'
{ pkgs }:

let
  # Import Node.js package manager governance packages
  prefer-pnpm = import ./prefer-pnpm.nix { inherit pkgs; };
  prefer-yarn = import ./prefer-yarn.nix { inherit pkgs; };
  prefer-bun = import ./prefer-bun.nix { inherit pkgs; };
  prefer-npm = import ./prefer-npm.nix { inherit pkgs; };
  prefer-yarn-from-pnpm = import ./prefer-yarn-from-pnpm.nix { inherit pkgs; };
  prefer-bun-from-pnpm = import ./prefer-bun-from-pnpm.nix { inherit pkgs; };
  prefer-npm-from-yarn = import ./prefer-npm-from-yarn.nix { inherit pkgs; };
  prefer-pnpm-from-yarn = import ./prefer-pnpm-from-yarn.nix { inherit pkgs; };
  prefer-bun-from-yarn = import ./prefer-bun-from-yarn.nix { inherit pkgs; };
  prefer-npm-from-bun = import ./prefer-npm-from-bun.nix { inherit pkgs; };
  prefer-pnpm-from-bun = import ./prefer-pnpm-from-bun.nix { inherit pkgs; };
  prefer-yarn-from-bun = import ./prefer-yarn-from-bun.nix { inherit pkgs; };
  
  # Include corepack for package manager management
  prefer-corepack = import ./prefer-corepack.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "nodejs-ecosystem";
  paths = [
    prefer-pnpm
    prefer-yarn
    prefer-bun
    prefer-npm
    prefer-yarn-from-pnpm
    prefer-bun-from-pnpm
    prefer-npm-from-yarn
    prefer-pnpm-from-yarn
    prefer-bun-from-yarn
    prefer-npm-from-bun
    prefer-pnpm-from-bun
    prefer-yarn-from-bun
    prefer-corepack
  ];
}
EOF

# Create Python ecosystem bundle
cat > nix/python-ecosystem.nix << 'EOF'
{ pkgs }:

let
  # Import Python package manager governance packages
  prefer-uv = import ./prefer-uv.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "python-ecosystem";
  paths = [
    prefer-uv
  ];
}
EOF

# Create Development Tools bundle
cat > nix/dev-tools.nix << 'EOF'
{ pkgs }:

let
  # Import development tool governance packages
  prefer-devbox = import ./prefer-devbox.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "dev-tools";
  paths = [
    prefer-devbox
  ];
}
EOF

# Create Migration bundles for specific scenarios
cat > nix/migrate-to-pnpm-bundle.nix << 'EOF'
{ pkgs }:

let
  # Import pnpm migration packages
  prefer-pnpm = import ./prefer-pnpm.nix { inherit pkgs; };
  force-pnpm-bundle = import ./force-pnpm.nix { inherit pkgs; };
  eject-npm = import ./eject-npm.nix { inherit pkgs; };
  eject-yarn-from-pnpm = import ./eject-yarn-from-pnpm.nix { inherit pkgs; };
  eject-bun-from-pnpm = import ./eject-bun-from-pnpm.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "migrate-to-pnpm";
  paths = [
    prefer-pnpm
    force-pnpm-bundle
    eject-npm
    eject-yarn-from-pnpm
    eject-bun-from-pnpm
  ];
}
EOF

cat > nix/migrate-to-uv-bundle.nix << 'EOF'
{ pkgs }:

let
  # Import uv migration packages
  prefer-uv = import ./prefer-uv.nix { inherit pkgs; };
  force-uv-bundle = import ./force-uv.nix { inherit pkgs; };
  eject-pip = import ./eject-pip.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "migrate-to-uv";
  paths = [
    prefer-uv
    force-uv-bundle
    eject-pip
  ];
}
EOF

echo "✅ Created logical bundles:"
echo "  - nodejs-ecosystem (Node.js package manager guidance)"
echo "  - python-ecosystem (Python package manager guidance)"
echo "  - dev-tools (Development tool guidance)"
echo "  - migrate-to-pnpm (Complete npm→pnpm migration)"
echo "  - migrate-to-uv (Complete pip→uv migration)"
