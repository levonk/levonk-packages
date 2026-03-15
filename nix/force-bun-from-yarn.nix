{ pkgs }:

let
  bun = pkgs.bun;
in
pkgs.writeShellScriptBin "yarn" ''
  #!/usr/bin/env sh
  echo "✅ Using bun instead of yarn (forced by policy)..."
  exec ${bun}/bin/bun "$@"
''
