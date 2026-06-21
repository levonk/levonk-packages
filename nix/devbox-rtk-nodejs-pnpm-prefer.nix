{ pkgs }:

let
  # Create the wrapper script
  wrapper = pkgs.writeShellScriptBin "npm" ''
    #!/usr/bin/env sh
    ${builtins.readFile ../wrappers/devbox-rtk-tools/nodejs-pnpm-prefer.sh}
  '';
  
  # Create pnpm wrapper (for direct pnpm calls)
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
  name = "devbox-rtk-nodejs-pnpm-prefer";
  paths = [
    wrapper
    pnpm-wrapper
  ];
}