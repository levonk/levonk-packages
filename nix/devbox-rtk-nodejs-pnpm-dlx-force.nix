{ pkgs }:

let
  # Import the shared library
  devbox-rtk-lib = import ./lib/devbox-rtk-lib.nix { inherit pkgs; };

  # Wrapper content for force governance logic
  # Strictly redirects one-off execution commands (npx, bunx, yarn dlx, bun x)
  # to `pnpm dlx` with no warning.
  wrapperContent = ''
    # Governance: Force npx/bunx/yarn dlx/bun x → pnpm dlx
    _called_as="$(basename "$0")"
    case "$_called_as" in
      npx|bunx)
        echo "✅ Using pnpm dlx instead of $_called_as (forced by policy)..."
        _dlx_translate_npx_args "$@"
        devbox_wrap pnpm dlx "''${_DLX_TRANSLATED_ARGS[@]}"
        ;;
      yarn)
        if [ "''${1:-}" = "dlx" ]; then
          echo "✅ Using pnpm dlx instead of yarn dlx (forced by policy)..."
          shift
          devbox_wrap pnpm dlx "$@"
        else
          devbox_wrap yarn "$@"
        fi
        ;;
      bun)
        if [ "''${1:-}" = "x" ]; then
          echo "✅ Using pnpm dlx instead of bun x (forced by policy)..."
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
  name = "devbox-rtk-nodejs-pnpm-dlx-force";
  paths = [
    npx-wrapper
    bunx-wrapper
    yarn-wrapper
    bun-wrapper
    pnpm-wrapper
  ];
}
