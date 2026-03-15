{ pkgs }:

pkgs.writeShellScriptBin "pip" ''
  #!/usr/bin/env sh
  echo "❌ pip is blocked by policy. Use uv instead."
  exit 1
''
