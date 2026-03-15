{ pkgs }:

let
  bun = pkgs.bun;
in
pkgs.writeShellScriptBin "npm" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer bun over npm. Running bun instead..."
  exec ${bun}/bin/bun "$@"
''
