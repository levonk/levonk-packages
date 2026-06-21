{ pkgs }:

let
  devbox-auto-cargo = import ./devbox-auto-cargo.nix { inherit pkgs; };
  devbox-auto-rustc = import ./devbox-auto-rustc.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "bundle-devbox-auto-rust";
  paths = [
    devbox-auto-cargo
    devbox-auto-rustc
  ];
}