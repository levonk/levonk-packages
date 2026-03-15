{ pkgs }:

pkgs.writeShellScriptBin "yarn" ''
  #!/usr/bin/env sh
  echo "❌ yarn is blocked by policy. Use npm instead."
  exit 1
''
