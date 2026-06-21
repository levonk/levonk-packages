{ pkgs }:

let
  devbox-auto-python = import ./devbox-auto-python.nix { inherit pkgs; };
  devbox-auto-pip = import ./devbox-auto-pip.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "bundle-devbox-auto-python";
  paths = [
    devbox-auto-python
    devbox-auto-pip
  ];
}