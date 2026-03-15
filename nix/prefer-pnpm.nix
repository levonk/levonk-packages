{ pkgs }:

let
  pnpm = pkgs.pnpm;
in
pkgs.writeShellScriptBin "npm" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer pnpm over npm. Running pnpm instead..."
  exec ${pnpm}/bin/pnpm "$@"
''
