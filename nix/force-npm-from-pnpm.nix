{ pkgs }:

let
  npm = pkgs.nodejs;
in
pkgs.writeShellScriptBin "pnpm" ''
  #!/usr/bin/env sh
  echo "✅ Using npm instead of pnpm (forced by policy)..."
  exec ${npm}/bin/npm "$@"
''
