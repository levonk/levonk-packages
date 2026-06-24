{ pkgs }:

let
  # Import the shared library
  devbox-auto-lib = import ./lib/devbox-auto-lib.nix { inherit pkgs; };
in
devbox-auto-lib {
  name = "pip";
  tool = "pip";
}