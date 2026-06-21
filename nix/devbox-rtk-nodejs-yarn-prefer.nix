{ pkgs }:

let
  # Create npm wrapper
  npm-wrapper = pkgs.writeScriptBin "npm" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-yarn-prefer.sh}
  '';
  
  # Create pnpm wrapper
  pnpm-wrapper = pkgs.writeScriptBin "pnpm" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-yarn-prefer.sh}
  '';
  
  # Create yarn wrapper
  yarn-wrapper = pkgs.writeScriptBin "yarn" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-yarn-prefer.sh}
  '';
in
pkgs.symlinkJoin {
  name = "devbox-rtk-nodejs-yarn-prefer";
  paths = [
    npm-wrapper
    pnpm-wrapper
    yarn-wrapper
  ];
}