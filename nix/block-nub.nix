{ pkgs }:

pkgs.writeShellScriptBin "nub" ''
  #!/usr/bin/env sh
  echo "❌ nub is blocked by policy. Use npm, pnpm, yarn, or bun instead."
  exit 1
''
