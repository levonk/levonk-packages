{ pkgs, lib }:

let
  # Import the shared library
  devbox-rtk-lib = import ../nix/lib/devbox-rtk-lib.nix { inherit pkgs; };
  
  # Wrapper content for native tool usage
  wrapperContent = ''
    # No governance - use tools as-is
    # Environment management + RTK optimization for called tool
    devbox_wrap "$(basename "$0")" "$@"
  '';
  
  # Create pip wrapper
  pip-wrapper = devbox-rtk-lib {
    name = "pip";
    inherit wrapperContent;
  };
  
  # Create uv wrapper
  uv-wrapper = devbox-rtk-lib {
    name = "uv";
    inherit wrapperContent;
  };
in
pkgs.symlinkJoin {
  name = "devbox-rtk-python-uv-native";
  paths = [
    pip-wrapper
    uv-wrapper
  ];
}