{ pkgs }:

pkgs.writeShellScriptBin "bun" ''
  #!/usr/bin/env sh
  echo "❌ bun is blocked by policy. Use yarn instead."
  exit 1
''
