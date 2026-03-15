{ pkgs }:

let
  yarn = pkgs.yarn;
in
pkgs.writeShellScriptBin "npm" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer yarn over npm. Running yarn instead..."
  exec ${yarn}/bin/yarn "$@"
''
