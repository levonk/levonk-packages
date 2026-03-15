{ pkgs }:

let
  # Import development tool governance packages
  prefer-devbox = import ./prefer-devbox.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "dev-tools";
  paths = [
    prefer-devbox
  ];
}
