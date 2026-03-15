{ pkgs }:

let
  pnpm = pkgs.pnpm;
in
pkgs.writeShellScriptBin "bun" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer pnpm over bun. Running pnpm instead..."
  exec ${pnpm}/bin/pnpm "$@"
''
