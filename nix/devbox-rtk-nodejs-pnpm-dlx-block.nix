{ pkgs }:

let
  # Import the shared library
  devbox-rtk-lib = import ./lib/devbox-rtk-lib.nix { inherit pkgs; };

  # Wrapper content for block governance logic
  # Blocks one-off execution commands (npx, bunx, yarn dlx, bun x) entirely.
  # Other invocations of `yarn` and `bun` (install/run/etc.) pass through.
  wrapperContent = ''
    # Governance: Block npx/bunx/yarn dlx/bun x
    _called_as="$(basename "$0")"
    case "$_called_as" in
      npx|bunx)
        echo "❌ $_called_as is blocked by policy. Use pnpm dlx instead."
        echo "💡 Install pnpm: https://pnpm.io/installation"
        exit 1
        ;;
      yarn)
        if [ "''${1:-}" = "dlx" ]; then
          echo "❌ yarn dlx is blocked by policy. Use pnpm dlx instead."
          echo "💡 Install pnpm: https://pnpm.io/installation"
          exit 1
        else
          devbox_wrap yarn "$@"
        fi
        ;;
      bun)
        if [ "''${1:-}" = "x" ]; then
          echo "❌ bun x is blocked by policy. Use pnpm dlx instead."
          echo "💡 Install pnpm: https://pnpm.io/installation"
          exit 1
        else
          devbox_wrap bun "$@"
        fi
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

  # Create yarn wrapper (intercepts `yarn dlx`)
  yarn-wrapper = devbox-rtk-lib {
    name = "yarn";
    inherit wrapperContent;
  };

  # Create bun wrapper (intercepts `bun x`)
  bun-wrapper = devbox-rtk-lib {
    name = "bun";
    inherit wrapperContent;
  };

  # Create pnpm wrapper (passthrough; lets `pnpm dlx` run natively)
  pnpm-wrapper = devbox-rtk-lib {
    name = "pnpm";
    inherit wrapperContent;
  };
in
pkgs.symlinkJoin {
  name = "devbox-rtk-nodejs-pnpm-dlx-block";
  paths = [
    npx-wrapper
    bunx-wrapper
    yarn-wrapper
    bun-wrapper
    pnpm-wrapper
  ];
}
