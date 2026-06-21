{ pkgs }:

let
  # Create pip wrapper
  pip-wrapper = pkgs.writeShellScriptBin "pip" ''
    #!/usr/bin/env sh
    ${builtins.readFile ../wrappers/devbox-rtk-tools/python-uv-prefer.sh}
  '';
  
  # Create uv wrapper
  uv-wrapper = pkgs.writeShellScriptBin "uv" ''
    #!/usr/bin/env sh
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -f "$SCRIPT_DIR/utils/devbox-manager.sh" ]; then
        . "$SCRIPT_DIR/utils/devbox-manager.sh"
    fi
    if [ -f "$SCRIPT_DIR/utils/rtk-wrapper.sh" ]; then
        . "$SCRIPT_DIR/utils/rtk-wrapper.sh"
    fi
    devbox_wrap uv "$@"
  '';
in
pkgs.symlinkJoin {
  name = "devbox-rtk-python-uv-prefer";
  paths = [
    pip-wrapper
    uv-wrapper
  ];
}