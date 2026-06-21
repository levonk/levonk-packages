{ pkgs }:

let
  # Create npm wrapper
  npm-wrapper = pkgs.writeShellScriptBin "npm" ''
    #!/usr/bin/env sh
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-bun-native.sh}
  '';
  
  # Create pnpm wrapper
  pnpm-wrapper = pkgs.writeShellScriptBin "pnpm" ''
    #!/usr/bin/env sh
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-bun-native.sh}
  '';
  
  # Create yarn wrapper
  yarn-wrapper = pkgs.writeShellScriptBin "yarn" ''
    #!/usr/bin/env sh
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-bun-native.sh}
  '';
  
  # Create bun wrapper
  bun-wrapper = pkgs.writeShellScriptBin "bun" ''
    #!/usr/bin/env sh
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
        . "$SCRIPT_DIR/utils/devbox-manager.sh"
    fi
    if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
        . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
    fi
    devbox_wrap bun "$@"
  '';
in
pkgs.symlinkJoin {
  name = "devbox-rtk-nodejs-bun-native";
  paths = [
    npm-wrapper
    pnpm-wrapper
    yarn-wrapper
    bun-wrapper
  ];
}