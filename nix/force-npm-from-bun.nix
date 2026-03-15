{ pkgs }:

let
  nodePackages.npm = pkgs.nodePackages.npm;
in
pkgs.writeShellScriptBin "bun" ''
  #!/usr/bin/env sh
  echo "✅ Using npm instead of bun (forced by policy)..."
  exec ${nodePackages.npm}/bin/npm "$@"
''
