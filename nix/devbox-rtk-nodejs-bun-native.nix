{ pkgs }:

let
  # Import the shared library
  devbox-rtk-lib = import ./lib/devbox-rtk-lib.nix { inherit pkgs; };
  
  # Wrapper content for native tool usage
  wrapperContent = ''
    # No governance - use tools as-is
    # Environment management + RTK optimization for called tool
    devbox_wrap "$(basename "$0")" "$@"
  '';
  
  # Create npm wrapper
  npm-wrapper = devbox-rtk-lib {
    name = "npm";
    inherit wrapperContent;
  };
  
  # Create pnpm wrapper
  pnpm-wrapper = devbox-rtk-lib {
    name = "pnpm";
    inherit wrapperContent;
  };
  
  # Create yarn wrapper
  yarn-wrapper = devbox-rtk-lib {
    name = "yarn";
    inherit wrapperContent;
  };
  
  # Create bun wrapper
  bun-wrapper = devbox-rtk-lib {
    name = "bun";
    inherit wrapperContent;
  };
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