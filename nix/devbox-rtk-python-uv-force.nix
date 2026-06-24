{ pkgs, lib }:

let
  # Import the shared library
  devbox-rtk-lib = import ../nix/lib/devbox-rtk-lib.nix { inherit pkgs; };
  
  # Wrapper content for force governance logic
  wrapperContent = ''
    # Governance: Force pip → uv
    if [ "$(basename "$0")" = "pip" ]; then
        echo "✅ Using uv instead of pip (forced by policy)..."
        set -- uv "$@"
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
  name = "devbox-rtk-python-uv-force";
  paths = [
    pip-wrapper
    uv-wrapper
  ];
}