{ pkgs }:

let
  pnpm = pkgs.pnpm;
in
pkgs.writeShellScriptBin "yarn" ''
  #!/usr/bin/env sh
  echo "✅ Using pnpm instead of yarn (forced by policy)..."
  exec ${pnpm}/bin/pnpm "$@"
''
