{ pkgs }:

let
  # Import the shared library
  devbox-rtk-lib = import ./lib/devbox-rtk-lib.nix { inherit pkgs; };

  # Wrapper content for native one-off runner usage.
  # No governance — each one-off runner is used as-is, with devbox + RTK still
  # applied for environment management and token optimization.
  wrapperContent = ''
    # No governance - use one-off runners as-is
    _called_as="$(basename "$0")"
    case "$_called_as" in
      npx|bunx|yarn|bun|pnpm)
        devbox_wrap "$_called_as" "$@"
        ;;
      *)
        devbox_wrap "$_called_as" "$@"
        ;;
    esac
  '';

  # Create npx wrapper
  npx-wrapper = devbox-rtk-lib {
    name = "npx";
    inherit wrapperContent;
  };

  # Create bunx wrapper
  bunx-wrapper = devbox-rtk-lib {
    name = "bunx";
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

  # Create pnpm wrapper
  pnpm-wrapper = devbox-rtk-lib {
    name = "pnpm";
    inherit wrapperContent;
  };
in
pkgs.symlinkJoin {
  name = "devbox-rtk-nodejs-pnpm-dlx-native";
  paths = [
    npx-wrapper
    bunx-wrapper
    yarn-wrapper
    bun-wrapper
    pnpm-wrapper
  ];
}
