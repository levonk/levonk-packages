{ pkgs }:

pkgs.writeShellScriptBin "npm" ''
  #!/usr/bin/env sh
  echo "❌ npm is blocked by policy. Use pnpm or corepack instead."
  exit 1
''
