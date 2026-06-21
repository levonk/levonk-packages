{ pkgs }:

let
  # Create npm wrapper
  npm-wrapper = pkgs.writeShellScriptBin "npm" ''
    #!/usr/bin/env sh
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-pnpm-native.sh}
  '';
  
  # Create pnpm wrapper
  pnpm-wrapper = pkgs.writeShellScriptBin "pnpm" ''
    #!/usr/bin/env sh
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
        . "$SCRIPT_DIR/utils/devbox-manager.sh"
    fi
    if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
        . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
    fi
    devbox_wrap pnpm "$@"
  '';
in
pkgs.symlinkJoin {
  name = "devbox-rtk-nodejs-pnpm-native";
  paths = [
    npm-wrapper
    pnpm-wrapper
  ];
}