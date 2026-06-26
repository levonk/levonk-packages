{ pkgs }:

pkgs.writeShellScriptBin "pnpm" ''
  #!/usr/bin/env sh
  echo "❌ pnpm has been ejected by policy."
  echo "pnpm has been removed and future installs are blocked."
  echo "Use nub instead."
  exit 1
''
