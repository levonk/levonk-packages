{ pkgs }:

let
  devbox-auto-npm = import ./devbox-auto-npm.nix { inherit pkgs; };
  devbox-auto-pnpm = import ./devbox-auto-pnpm.nix { inherit pkgs; };
  devbox-auto-yarn = import ./devbox-auto-yarn.nix { inherit pkgs; };
  devbox-auto-python = import ./devbox-auto-python.nix { inherit pkgs; };
  devbox-auto-pip = import ./devbox-auto-pip.nix { inherit pkgs; };
  devbox-auto-cargo = import ./devbox-auto-cargo.nix { inherit pkgs; };
  devbox-auto-rustc = import ./devbox-auto-rustc.nix { inherit pkgs; };
  devbox-auto-go = import ./devbox-auto-go.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "bundle-devbox-auto-all";
  paths = [
    devbox-auto-npm
    devbox-auto-pnpm
    devbox-auto-yarn
    devbox-auto-python
    devbox-auto-pip
    devbox-auto-cargo
    devbox-auto-rustc
    devbox-auto-go
  ];
}