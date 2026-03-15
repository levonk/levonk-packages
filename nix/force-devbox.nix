{ pkgs }:

let
  devbox = pkgs.devbox;
  
in
pkgs.writeShellScriptBin "curl" ''
  #!/usr/bin/env sh
  echo "✅ Using devbox instead of curl (forced by policy)..."
  echo "💡 Use 'devbox' commands for environment setup instead of curl."
  exit 0
''
