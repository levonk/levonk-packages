{ pkgs }:

let
  node = pkgs.nodejs;
in
pkgs.writeShellScriptBin "node" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer corepack for package manager management. Use corepack enable/disable..."
  echo "Node.js is still available for runtime execution."
  exec ${node}/bin/node "$@"
''
