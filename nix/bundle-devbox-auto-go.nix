{ pkgs }:

let
  devbox-auto-go = import ./devbox-auto-go.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "bundle-devbox-auto-go";
  paths = [
    devbox-auto-go
  ];
}