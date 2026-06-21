{ pkgs }:

let
  # Create the wrapper script
  wrapper = pkgs.writeScriptBin "npm" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-pnpm-block.sh}
  '';
  
  # Create pnpm wrapper (for direct pnpm calls)
  pnpm-wrapper = pkgs.writeScriptBin "pnpm" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-pnpm-block.sh}
  '';
in
pkgs.symlinkJoin {
  name = "devbox-rtk-nodejs-pnpm-block";
  paths = [
    wrapper
    pnpm-wrapper
  ];
}