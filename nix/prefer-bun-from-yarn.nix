{ pkgs }:

let
  bun = pkgs.bun;
in
pkgs.writeShellScriptBin "yarn" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer bun over yarn. Running bun instead..."
  exec ${bun}/bin/bun "$@"
''
