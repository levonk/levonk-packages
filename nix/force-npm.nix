{ pkgs }:

let
  npm = pkgs.nodejs;
  # pnpm → npm
  force-npm-from-pnpm = import ./force-npm-from-pnpm.nix { inherit pkgs; };
  # yarn → npm
  force-npm-from-yarn = pkgs.writeShellScriptBin "yarn" ''
    #!/usr/bin/env sh
    echo "✅ Using npm instead of yarn (forced by policy)..."
    exec ${npm}/bin/npm "$@"
  '';
  # bun → npm
  force-npm-from-bun = pkgs.writeShellScriptBin "bun" ''
    #!/usr/bin/env sh
    echo "✅ Using npm instead of bun (forced by policy)..."
    exec ${npm}/bin/npm "$@"
  '';
in
pkgs.symlinkJoin {
  name = "force-npm";
  paths = [
    force-npm-from-pnpm
    force-npm-from-yarn
    force-npm-from-bun
  ];
}
