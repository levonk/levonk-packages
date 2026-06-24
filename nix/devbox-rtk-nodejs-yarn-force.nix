{ pkgs, lib }:

let
  # Import the shared library
  devbox-rtk-lib = import ../nix/lib/devbox-rtk-lib.nix { inherit pkgs; };
  
  # Wrapper content for force governance logic
  wrapperContent = ''
    # Governance: Force npm/pnpm → yarn
    case "$(basename "$0")" in
        npm|pnpm)
            echo "✅ Using yarn instead of $(basename "$0") (forced by policy)..."
            set -- yarn "$@"
            ;;
    esac

    # Environment management + RTK optimization for yarn
    devbox_wrap yarn "$@"
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
in
pkgs.symlinkJoin {
  name = "devbox-rtk-nodejs-yarn-force";
  paths = [
    npm-wrapper
    pnpm-wrapper
    yarn-wrapper
  ];
}