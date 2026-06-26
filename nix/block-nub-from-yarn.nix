{ pkgs }:

pkgs.writeShellScriptBin "yarn" ''
  #!/usr/bin/env sh
  echo "❌ yarn is blocked by policy. Use nub instead."
  exit 1
''
