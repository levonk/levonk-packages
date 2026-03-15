#!/bin/bash
set -euo pipefail

# Update bundle-command-governance.nix with all packages

cat > nix/bundle-command-governance.nix << 'EOF'
{ pkgs }:

let
  # Import all individual packages
  prefer-pnpm = import ./prefer-pnpm.nix { inherit pkgs; };
  eject-npm = import ./eject-npm.nix { inherit pkgs; };
  force-pnpm = import ./force-pnpm.nix { inherit pkgs; };
  block-npm = import ./block-npm.nix { inherit pkgs; };
  prefer-yarn = import ./prefer-yarn.nix { inherit pkgs; };
  eject-yarn = import ./eject-yarn.nix { inherit pkgs; };
  force-yarn = import ./force-yarn.nix { inherit pkgs; };
  block-yarn = import ./block-yarn.nix { inherit pkgs; };
  prefer-bun = import ./prefer-bun.nix { inherit pkgs; };
  eject-bun = import ./eject-bun.nix { inherit pkgs; };
  force-bun = import ./force-bun.nix { inherit pkgs; };
  block-bun = import ./block-bun.nix { inherit pkgs; };
  
  prefer-uv = import ./prefer-uv.nix { inherit pkgs; };
  eject-pip = import ./eject-pip.nix { inherit pkgs; };
  block-pip = import ./block-pip.nix { inherit pkgs; };
  
  prefer-npm = import ./prefer-npm.nix { inherit pkgs; };
  force-npm = import ./force-npm.nix { inherit pkgs; };
  eject-pnpm = import ./eject-pnpm.nix { inherit pkgs; };
  block-pnpm = import ./block-pnpm.nix { inherit pkgs; };
  
  prefer-yarn-from-pnpm = import ./prefer-yarn-from-pnpm.nix { inherit pkgs; };
  force-yarn-from-pnpm = import ./force-yarn-from-pnpm.nix { inherit pkgs; };
  block-yarn-from-pnpm = import ./block-yarn-from-pnpm.nix { inherit pkgs; };
  eject-yarn-from-pnpm = import ./eject-yarn-from-pnpm.nix { inherit pkgs; };
  
  prefer-bun-from-pnpm = import ./prefer-bun-from-pnpm.nix { inherit pkgs; };
  force-bun-from-pnpm = import ./force-bun-from-pnpm.nix { inherit pkgs; };
  block-bun-from-pnpm = import ./block-bun-from-pnpm.nix { inherit pkgs; };
  eject-bun-from-pnpm = import ./eject-bun-from-pnpm.nix { inherit pkgs; };
  
  prefer-npm-from-yarn = import ./prefer-npm-from-yarn.nix { inherit pkgs; };
  force-npm-from-yarn = import ./force-npm-from-yarn.nix { inherit pkgs; };
  block-npm-from-yarn = import ./block-npm-from-yarn.nix { inherit pkgs; };
  eject-npm-from-yarn = import ./eject-npm-from-yarn.nix { inherit pkgs; };
  
  prefer-pnpm-from-yarn = import ./prefer-pnpm-from-yarn.nix { inherit pkgs; };
  force-pnpm-from-yarn = import ./force-pnpm-from-yarn.nix { inherit pkgs; };
  block-pnpm-from-yarn = import ./block-pnpm-from-yarn.nix { inherit pkgs; };
  eject-pnpm-from-yarn = import ./eject-pnpm-from-yarn.nix { inherit pkgs; };
  
  prefer-bun-from-yarn = import ./prefer-bun-from-yarn.nix { inherit pkgs; };
  force-bun-from-yarn = import ./force-bun-from-yarn.nix { inherit pkgs; };
  block-bun-from-yarn = import ./block-bun-from-yarn.nix { inherit pkgs; };
  eject-bun-from-yarn = import ./eject-bun-from-yarn.nix { inherit pkgs; };
  
  prefer-npm-from-bun = import ./prefer-npm-from-bun.nix { inherit pkgs; };
  force-npm-from-bun = import ./force-npm-from-bun.nix { inherit pkgs; };
  block-npm-from-bun = import ./block-npm-from-bun.nix { inherit pkgs; };
  eject-npm-from-bun = import ./eject-npm-from-bun.nix { inherit pkgs; };
  
  prefer-pnpm-from-bun = import ./prefer-pnpm-from-bun.nix { inherit pkgs; };
  force-pnpm-from-bun = import ./force-pnpm-from-bun.nix { inherit pkgs; };
  block-pnpm-from-bun = import ./block-pnpm-from-bun.nix { inherit pkgs; };
  eject-pnpm-from-bun = import ./eject-pnpm-from-bun.nix { inherit pkgs; };
  
  prefer-yarn-from-bun = import ./prefer-yarn-from-bun.nix { inherit pkgs; };
  force-yarn-from-bun = import ./force-yarn-from-bun.nix { inherit pkgs; };
  block-yarn-from-bun = import ./block-yarn-from-bun.nix { inherit pkgs; };
  eject-yarn-from-bun = import ./eject-yarn-from-bun.nix { inherit pkgs; };
  
  prefer-devbox = import ./prefer-devbox.nix { inherit pkgs; };
  prefer-corepack = import ./prefer-corepack.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "command-governance";
  paths = [
    prefer-pnpm
    eject-npm
    force-pnpm
    block-npm
    prefer-yarn
    eject-yarn
    force-yarn
    block-yarn
    prefer-bun
    eject-bun
    force-bun
    block-bun
    prefer-uv
    eject-pip
    block-pip
    prefer-npm
    force-npm
    eject-pnpm
    block-pnpm
    prefer-yarn-from-pnpm
    force-yarn-from-pnpm
    block-yarn-from-pnpm
    eject-yarn-from-pnpm
    prefer-bun-from-pnpm
    force-bun-from-pnpm
    block-bun-from-pnpm
    eject-bun-from-pnpm
    prefer-npm-from-yarn
    force-npm-from-yarn
    block-npm-from-yarn
    eject-npm-from-yarn
    prefer-pnpm-from-yarn
    force-pnpm-from-yarn
    block-pnpm-from-yarn
    eject-pnpm-from-yarn
    prefer-bun-from-yarn
    force-bun-from-yarn
    block-bun-from-yarn
    eject-bun-from-yarn
    prefer-npm-from-bun
    force-npm-from-bun
    block-npm-from-bun
    eject-npm-from-bun
    prefer-pnpm-from-bun
    force-pnpm-from-bun
    block-pnpm-from-bun
    eject-pnpm-from-bun
    prefer-yarn-from-bun
    force-yarn-from-bun
    block-yarn-from-bun
    eject-yarn-from-bun
    prefer-devbox
    prefer-corepack
  ];
}
EOF

echo "Updated bundle-command-governance.nix with all packages!"
