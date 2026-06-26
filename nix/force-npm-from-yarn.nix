{ pkgs }:

let
  npm = pkgs.nodejs;
in
pkgs.writeShellScriptBin "yarn" ''
  #!/usr/bin/env sh
  echo "✅ Using npm instead of yarn (forced by policy)..."
  exec ${npm}/bin/npm "$@"
''
