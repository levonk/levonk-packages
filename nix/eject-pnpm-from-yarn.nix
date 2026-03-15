{ pkgs }:

pkgs.writeShellScriptBin "yarn" ''
  #!/usr/bin/env sh
  echo "❌ yarn has been ejected by policy."
  echo "yarn has been removed and future installs are blocked."
  echo "Use pnpm instead."
  exit 1
''
