{ pkgs, lib }:

let
  # Import the shared library
  devbox-rtk-lib = import ./lib/devbox-rtk-lib.nix { inherit pkgs; };
  
  # Wrapper content for force governance logic
  wrapperContent = ''
    # Governance: Force npm → pnpm
    if [ "$(basename "$0")" = "npm" ]; then
        echo "✅ Using pnpm instead of npm (forced by policy)..."
        set -- pnpm "$@"
    fi

    # Environment management + RTK optimization for pnpm
    devbox_wrap pnpm "$@"
  '';
  
  # Create npm wrapper
  npm-wrapper = devbox-rtk-lib {
    name = "npm";
    inherit wrapperContent;
  };
  
  # Create pnpm wrapper (for direct pnpm calls)
  pnpm-wrapper = devbox-rtk-lib {
    name = "pnpm";
    inherit wrapperContent;
  };
in
pkgs.symlinkJoin {
  name = "devbox-rtk-nodejs-pnpm-force";
  paths = [
    npm-wrapper
    pnpm-wrapper
  ];
}