{ pkgs }:

let
  npm = pkgs.nodePackages.npm;
in
pkgs.writeShellScriptBin "pnpm" ''
  #!/usr/bin/env sh
  echo "✅ Using npm instead of pnpm (forced by policy)..."
  exec ${npm}/bin/npm "$@"
''
