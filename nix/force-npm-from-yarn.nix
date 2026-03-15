{ pkgs }:

let
  nodePackages.npm = pkgs.nodePackages.npm;
in
pkgs.writeShellScriptBin "yarn" ''
  #!/usr/bin/env sh
  echo "✅ Using npm instead of yarn (forced by policy)..."
  exec ${nodePackages.npm}/bin/npm "$@"
''
