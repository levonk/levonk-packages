{ pkgs }:

let
  # Create the wrapper script
  wrapper = pkgs.writeScriptBin "npm" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-pnpm-prefer.sh}
  '';
  
  # Create pnpm wrapper (for direct pnpm calls)
  pnpm-wrapper = pkgs.writeScriptBin "pnpm" ''
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-pnpm-prefer.sh}
  '';
in
pkgs.symlinkJoin {
  name = "devbox-rtk-nodejs-pnpm-prefer";
  paths = [
    wrapper
    pnpm-wrapper
  ];
}