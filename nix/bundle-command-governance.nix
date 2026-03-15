{ pkgs }:

let
  # Import all individual packages
  prefer-pnpm = import ./prefer-pnpm.nix { inherit pkgs; };
  eject-npm = import ./eject-npm.nix { inherit pkgs; };
  force-pnpm = import ./force-pnpm.nix { inherit pkgs; };
  block-npm = import ./block-npm.nix { inherit pkgs; };
  prefer-uv = import ./prefer-uv.nix { inherit pkgs; };
  eject-pip = import ./eject-pip.nix { inherit pkgs; };
  block-pip = import ./block-pip.nix { inherit pkgs; };
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
    prefer-uv
    eject-pip
    block-pip
    prefer-devbox
    prefer-corepack
  ];
}
