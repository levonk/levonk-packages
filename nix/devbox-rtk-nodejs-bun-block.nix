{ pkgs, lib }:

let
  # Import the shared library
  devbox-rtk-lib = import ../nix/lib/devbox-rtk-lib.nix { inherit pkgs; };
  
  # Wrapper content for governance logic
  wrapperContent = ''
    # Governance: Block npm/pnpm/yarn
    case "$(basename "$0")" in
        npm|pnpm|yarn)
            echo "❌ $(basename "$0") is blocked by policy. Use bun instead."
            echo "💡 Install bun: https://bun.sh/docs/installation"
            exit 1
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
  name = "devbox-rtk-nodejs-bun-block";
  paths = [
    npm-wrapper
    pnpm-wrapper
    yarn-wrapper
    bun-wrapper
  ];
}