{ pkgs }:

let
  nodePackages.npm = pkgs.nodePackages.npm;
in
pkgs.writeShellScriptBin "yarn" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer npm over yarn. Running npm instead..."
  exec ${nodePackages.npm}/bin/npm "$@"
''
