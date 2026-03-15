{ pkgs }:

pkgs.writeShellScriptBin "bun" ''
  #!/usr/bin/env sh
  echo "❌ bun is blocked by policy. Use npm instead."
  exit 1
''
