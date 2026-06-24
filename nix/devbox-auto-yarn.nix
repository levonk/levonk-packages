{ pkgs, lib }:

let
  # Import the shared library
  devbox-auto-lib = import ../nix/lib/devbox-auto-lib.nix { inherit pkgs; };
in
devbox-auto-lib {
  name = "yarn";
  tool = "yarn";
}