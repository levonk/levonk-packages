{ pkgs }:

let
  # Import force packages that replace with pnpm
  force-yarn-from-pnpm = import ./force-yarn-from-pnpm.nix { inherit pkgs; };
  force-bun-from-pnpm = import ./force-bun-from-pnpm.nix { inherit pkgs; };
  
  # Import eject packages (dependencies)
  eject-npm = import ./eject-npm.nix { inherit pkgs; };
  eject-yarn-from-pnpm = import ./eject-yarn-from-pnpm.nix { inherit pkgs; };
  eject-bun-from-pnpm = import ./eject-bun-from-pnpm.nix { inherit pkgs; };
  
  # The actual force-pnpm wrapper
  pnpm = pkgs.nodePackages.pnpm;
  force-pnpm-wrapper = pkgs.writeShellScriptBin "npm" ''
    #!/usr/bin/env sh
    echo "✅ Using pnpm instead of npm (forced by policy)..."
    exec ${pnpm}/bin/pnpm "$@"
  '';
in
pkgs.symlinkJoin {
  name = "force-pnpm";
  paths = [
    force-pnpm-wrapper
    force-yarn-from-pnpm
    force-bun-from-pnpm
    eject-npm
    eject-yarn-from-pnpm
    eject-bun-from-pnpm
  ];
}
