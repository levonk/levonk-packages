{ pkgs }:

let
  # Create npm wrapper
  npm-wrapper = pkgs.writeScriptBin "npm" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-pnpm-native.sh}
  '';
  
  # Create pnpm wrapper
  pnpm-wrapper = pkgs.writeScriptBin "pnpm" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-pnpm-native.sh}
  '';
in
pkgs.symlinkJoin {
  name = "devbox-rtk-nodejs-pnpm-native";
  paths = [
    npm-wrapper
    pnpm-wrapper
  ];
}