{ pkgs }:

let
  pnpm = pkgs.pnpm;
  # npm → pnpm (main wrapper)
  force-pnpm-npm = pkgs.writeShellScriptBin "npm" ''
    #!/usr/bin/env sh
    echo "✅ Using pnpm instead of npm (forced by policy)..."
    exec ${pnpm}/bin/pnpm "$@"
  '';
  # yarn → pnpm
  force-pnpm-from-yarn = import ./force-pnpm-from-yarn.nix { inherit pkgs; };
  # bun → pnpm
  force-pnpm-from-bun = import ./force-pnpm-from-bun.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "force-pnpm";
  paths = [
    force-pnpm-npm
    force-pnpm-from-yarn
    force-pnpm-from-bun
  ];
}
