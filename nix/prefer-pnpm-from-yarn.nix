{ pkgs }:

let
  pnpm = pkgs.pnpm;
in
pkgs.writeShellScriptBin "yarn" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer pnpm over yarn. Running pnpm instead..."
  exec ${pnpm}/bin/pnpm "$@"
''
