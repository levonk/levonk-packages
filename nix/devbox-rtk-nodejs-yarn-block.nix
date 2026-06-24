{ pkgs, lib }:

let
  # Import the shared library
  devbox-rtk-lib = import ../nix/lib/devbox-rtk-lib.nix { inherit pkgs; };
  
  # Wrapper content for block governance logic
  wrapperContent = ''
    # Governance: Block npm/pnpm
    case "$(basename "$0")" in
        npm|pnpm)
            echo "❌ $(basename "$0") is blocked by policy. Use yarn instead."
            echo "💡 Install yarn: https://yarnpkg.com/getting-started/install"
            exit 1
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
  name = "devbox-rtk-nodejs-yarn-block";
  paths = [
    npm-wrapper
    pnpm-wrapper
    yarn-wrapper
  ];
}