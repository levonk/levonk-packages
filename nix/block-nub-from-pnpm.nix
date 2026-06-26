{ pkgs }:

pkgs.writeShellScriptBin "pnpm" ''
  #!/usr/bin/env sh
  echo "❌ pnpm is blocked by policy. Use nub instead."
  exit 1
''
