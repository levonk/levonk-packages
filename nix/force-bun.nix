{ pkgs }:

let
  bun = pkgs.bun;
in
pkgs.writeShellScriptBin "npm" ''
  #!/usr/bin/env sh
  echo "✅ Using bun instead of npm (forced by policy)..."
  exec ${bun}/bin/bun "$@"
''
