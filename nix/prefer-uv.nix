{ pkgs }:

let
  uv = pkgs.uv;
in
pkgs.writeShellScriptBin "pip" ''
  #!/usr/bin/env sh
  echo "⚠️ Prefer uv over pip. Running uv instead..."
  exec ${uv}/bin/uv "$@"
''
