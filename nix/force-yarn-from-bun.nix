{ pkgs }:

let
  yarn = pkgs.yarn;
in
pkgs.writeShellScriptBin "bun" ''
  #!/usr/bin/env sh
  echo "✅ Using yarn instead of bun (forced by policy)..."
  exec ${yarn}/bin/yarn "$@"
''
