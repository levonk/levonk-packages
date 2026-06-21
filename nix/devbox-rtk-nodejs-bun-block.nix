{ pkgs }:

let
  # Create npm wrapper
  npm-wrapper = pkgs.writeScriptBin "npm" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-bun-block.sh}
  '';
  
  # Create pnpm wrapper
  pnpm-wrapper = pkgs.writeScriptBin "pnpm" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-bun-block.sh}
  '';
  
  # Create yarn wrapper
  yarn-wrapper = pkgs.writeScriptBin "yarn" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-bun-block.sh}
  '';
  
  # Create bun wrapper
  bun-wrapper = pkgs.writeScriptBin "bun" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-bun-block.sh}
  '';
in
pkgs.symlinkJoin {
  name = "devbox-rtk-nodejs-bun-block";
  paths = [
    npm-wrapper
    pnpm-wrapper
    yarn-wrapper
    bun-wrapper
  ];
}