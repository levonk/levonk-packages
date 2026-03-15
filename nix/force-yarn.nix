{ pkgs }:

let
  yarn = pkgs.yarn;
in
pkgs.writeShellScriptBin "npm" ''
  #!/usr/bin/env sh
  echo "✅ Using yarn instead of npm (forced by policy)..."
  exec ${yarn}/bin/yarn "$@"
''
