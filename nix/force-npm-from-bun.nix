{ pkgs }:

let
  npm = pkgs.nodejs;
in
pkgs.writeShellScriptBin "bun" ''
  #!/usr/bin/env sh
  echo "✅ Using npm instead of bun (forced by policy)..."
  exec ${npm}/bin/npm "$@"
''
