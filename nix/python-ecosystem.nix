{ pkgs }:

let
  # Import Python package manager governance packages
  prefer-uv = import ./prefer-uv.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "python-ecosystem";
  paths = [
    prefer-uv
  ];
}
