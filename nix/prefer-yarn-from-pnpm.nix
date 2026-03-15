{ pkgs }:

let
  yarn = pkgs.yarn;
in
pkgs.writeShellScriptBin "pnpm" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer yarn over pnpm. Running yarn instead..."
  exec ${yarn}/bin/yarn "$@"
''
