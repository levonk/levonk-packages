{ pkgs }:

pkgs.writeShellScriptBin "nub" ''
  #!/usr/bin/env sh
  echo "❌ nub has been ejected by policy."
  echo "nub has been removed and future installs are blocked."
  echo "Use npm, pnpm, yarn, or bun instead."
  exit 1
''
