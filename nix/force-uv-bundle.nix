{ pkgs }:

let
  # Import force package for uv
  force-uv = import ./force-uv.nix { inherit pkgs; };
  
  # Import eject package (dependency)
  eject-pip = import ./eject-pip.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "force-uv";
  paths = [
    force-uv
    eject-pip
  ];
}
