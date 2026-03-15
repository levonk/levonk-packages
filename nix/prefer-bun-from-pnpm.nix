{ pkgs }:

let
  bun = pkgs.bun;
in
pkgs.writeShellScriptBin "pnpm" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer bun over pnpm. Running bun instead..."
  exec ${bun}/bin/bun "$@"
''
