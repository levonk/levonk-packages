{ pkgs }:

let
  pnpm = pkgs.pnpm;
in
pkgs.writeShellScriptBin "npm" ''
  #!/usr/bin/env sh
  echo "✅ Using pnpm instead of npm (forced by policy)..."
  exec ${pnpm}/bin/pnpm "$@"
''
