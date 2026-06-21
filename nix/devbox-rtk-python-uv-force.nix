{ pkgs }:

let
  # Create pip wrapper
  pip-wrapper = pkgs.writeScriptBin "pip" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/python-uv-force.sh}
  '';
  
  # Create uv wrapper
  uv-wrapper = pkgs.writeScriptBin "uv" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/python-uv-force.sh}
  '';
in
pkgs.symlinkJoin {
  name = "devbox-rtk-python-uv-force";
  paths = [
    pip-wrapper
    uv-wrapper
  ];
}