{ pkgs, lib }:

let
  # Import the shared library
  devbox-rtk-lib = import ./lib/devbox-rtk-lib.nix { inherit pkgs; };
  
  # Wrapper content for block governance logic
  wrapperContent = ''
    # Governance: Block pip
    if [ "$(basename "$0")" = "pip" ]; then
        echo "❌ pip is blocked by policy. Use uv instead."
        echo "💡 Install uv: https://github.com/astral-sh/uv"
        exit 1
    fi

    # Environment management + RTK optimization for uv
    devbox_wrap uv "$@"
  '';
  
  # Create pip wrapper
  pip-wrapper = devbox-rtk-lib {
    name = "pip";
    inherit wrapperContent;
  };
  
  # Create uv wrapper
  uv-wrapper = devbox-rtk-lib {
    name = "uv";
    inherit wrapperContent;
  };
in
pkgs.symlinkJoin {
  name = "devbox-rtk-python-uv-block";
  paths = [
    pip-wrapper
    uv-wrapper
  ];
}