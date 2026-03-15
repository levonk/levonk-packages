{ pkgs }:

let
  # Import uv migration packages
  prefer-uv = import ./prefer-uv.nix { inherit pkgs; };
  force-uv-bundle = import ./force-uv.nix { inherit pkgs; };
  eject-pip = import ./eject-pip.nix { inherit pkgs; };
  
in
pkgs.symlinkJoin {
  name = "migrate-to-uv";
  paths = [
    prefer-uv
    force-uv-bundle
    eject-pip
  ];
}
