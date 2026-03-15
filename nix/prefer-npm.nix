{ pkgs }:

let
  npm = pkgs.nodePackages.npm;
in
pkgs.writeShellScriptBin "pnpm" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer npm over pnpm. Running npm instead..."
  exec ${npm}/bin/npm "$@"
''
