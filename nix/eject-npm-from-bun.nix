{ pkgs }:

pkgs.writeShellScriptBin "bun" ''
  #!/usr/bin/env sh
  echo "❌ bun has been ejected by policy."
  echo "bun has been removed and future installs are blocked."
  echo "Use npm instead."
  exit 1
''
