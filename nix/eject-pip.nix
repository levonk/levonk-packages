{ pkgs }:

pkgs.writeShellScriptBin "pip" ''
  #!/usr/bin/env sh
  echo "❌ pip has been ejected by policy."
  echo "pip has been removed and future installs are blocked."
  echo "Use uv or python -m pip instead."
  exit 1
''
