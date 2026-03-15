{ pkgs }:

let
  # Import force package for devbox
  force-devbox = import ./force-devbox.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "force-devbox";
  paths = [
    force-devbox
  ];
}
