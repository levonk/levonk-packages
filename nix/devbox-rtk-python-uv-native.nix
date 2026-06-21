{ pkgs }:

let
  # Create pip wrapper
  pip-wrapper = pkgs.writeScriptBin "pip" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/python-uv-native.sh}
  '';
  
  # Create uv wrapper
  uv-wrapper = pkgs.writeScriptBin "uv" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/python-uv-native.sh}
  '';
in
pkgs.symlinkJoin {
  name = "devbox-rtk-python-uv-native";
  paths = [
    pip-wrapper
    uv-wrapper
  ];
}