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
