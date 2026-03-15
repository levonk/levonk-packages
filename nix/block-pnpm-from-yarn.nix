{ pkgs }:

pkgs.writeShellScriptBin "yarn" ''
  #!/usr/bin/env sh
  echo "❌ yarn is blocked by policy. Use pnpm instead."
  exit 1
''
