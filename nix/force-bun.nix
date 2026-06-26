{ pkgs }:

let
  bun = pkgs.bun;
  # npm → bun (main wrapper)
  force-bun-npm = pkgs.writeShellScriptBin "npm" ''
    #!/usr/bin/env sh
    echo "✅ Using bun instead of npm (forced by policy)..."
    exec ${bun}/bin/bun "$@"
  '';
  # pnpm → bun
  force-bun-from-pnpm = import ./force-bun-from-pnpm.nix { inherit pkgs; };
  # yarn → bun
  force-bun-from-yarn = import ./force-bun-from-yarn.nix { inherit pkgs; };
in
pkgs.symlinkJoin {
  name = "force-bun";
  paths = [
    force-bun-npm
    force-bun-from-pnpm
    force-bun-from-yarn
  ];
}
