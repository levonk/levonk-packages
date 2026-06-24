{ pkgs, lib }:

let
  # Import the shared library
  devbox-rtk-lib = import ./lib/devbox-rtk-lib.nix { inherit pkgs; };
  
  # Wrapper content for prefer governance logic
  wrapperContent = ''
    # Governance: Prefer npm/pnpm/yarn → bun
    case "$(basename "$0")" in
        npm|pnpm|yarn)
            echo "⚠️ Prefer bun over $(basename "$0"). Using bun..."
            set -- bun "$@"
            ;;
    esac

    # Environment management + RTK optimization for bun
    devbox_wrap bun "$@"
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
  name = "devbox-rtk-nodejs-bun-prefer";
  paths = [
    npm-wrapper
    pnpm-wrapper
    yarn-wrapper
    bun-wrapper
  ];
}