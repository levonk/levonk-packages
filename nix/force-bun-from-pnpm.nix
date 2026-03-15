{ pkgs }:

let
  bun = pkgs.bun;
in
pkgs.writeShellScriptBin "pnpm" ''
  #!/usr/bin/env sh
  echo "✅ Using bun instead of pnpm (forced by policy)..."
  exec ${bun}/bin/bun "$@"
''
