{ pkgs }:

let
  uv = pkgs.uv;
  
in
pkgs.writeShellScriptBin "pip" ''
  #!/usr/bin/env sh
  echo "✅ Using uv instead of pip (forced by policy)..."
  exec ${uv}/bin/uv "$@"
''
