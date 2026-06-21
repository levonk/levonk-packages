{ pkgs }:

let
  devbox-auto-npm = import ./devbox-auto-npm.nix { inherit pkgs; };
  devbox-auto-pnpm = import ./devbox-auto-pnpm.nix { inherit pkgs; };
  devbox-auto-yarn = import ./devbox-auto-yarn.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "bundle-devbox-auto-nodejs";
  paths = [
    devbox-auto-npm
    devbox-auto-pnpm
    devbox-auto-yarn
  ];
}