{ pkgs }:

pkgs.writeShellScriptBin "npm" ''
  #!/usr/bin/env sh
  echo "❌ npm is blocked by policy. Use bun instead."
  exit 1
''
