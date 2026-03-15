{ pkgs }:

let
  nodePackages.npm = pkgs.nodePackages.npm;
in
pkgs.writeShellScriptBin "bun" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer npm over bun. Running npm instead..."
  exec ${nodePackages.npm}/bin/npm "$@"
''
