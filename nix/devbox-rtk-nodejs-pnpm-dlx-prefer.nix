{ pkgs }:

let
  # Import the shared library
  devbox-rtk-lib = import ./lib/devbox-rtk-lib.nix { inherit pkgs; };

  # Wrapper content for prefer governance logic
  # Wraps the one-off execution commands (npx, bunx) and redirects to `pnpm dlx`.
  # `yarn dlx` and `bun x` share binaries with `yarn`/`bun` and are handled by
  # subcommand inspection inside the same wrapper for completeness.
  wrapperContent = ''
    # Governance: Prefer npx/bunx/yarn dlx/bun x → pnpm dlx
    _called_as="$(basename "$0")"
    case "$_called_as" in
      npx|bunx)
        echo "⚠️ Prefer pnpm dlx over $_called_as. Using pnpm dlx..."
        devbox_wrap pnpm dlx "$@"
        ;;
      yarn)
        if [ "''${1:-}" = "dlx" ]; then
          echo "⚠️ Prefer pnpm dlx over yarn dlx. Using pnpm dlx..."
          shift
          devbox_wrap pnpm dlx "$@"
        else
          devbox_wrap yarn "$@"
        fi
        ;;
      bun)
        if [ "''${1:-}" = "x" ]; then
          echo "⚠️ Prefer pnpm dlx over bun x. Using pnpm dlx..."
          shift
          devbox_wrap pnpm dlx "$@"
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
  name = "devbox-rtk-nodejs-pnpm-dlx-prefer";
  paths = [
    npx-wrapper
    bunx-wrapper
    yarn-wrapper
    bun-wrapper
    pnpm-wrapper
  ];
}
