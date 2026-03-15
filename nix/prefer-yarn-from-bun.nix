{ pkgs }:

let
  yarn = pkgs.yarn;
in
pkgs.writeShellScriptBin "bun" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer yarn over bun. Running yarn instead..."
  exec ${yarn}/bin/yarn "$@"
''
