{ pkgs }:

let
  pnpm = pkgs.pnpm;
in
pkgs.writeShellScriptBin "bun" ''
  #!/usr/bin/env sh
  echo "✅ Using pnpm instead of bun (forced by policy)..."
  exec ${pnpm}/bin/pnpm "$@"
''
