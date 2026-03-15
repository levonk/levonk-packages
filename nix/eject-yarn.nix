{ pkgs }:

pkgs.writeShellScriptBin "npm" ''
  #!/usr/bin/env sh
  echo "❌ npm has been ejected by policy."
  echo "npm is bundled with nodejs and cannot be removed without removing nodejs."
  echo "npm has been shadowed and future installs are blocked."
  exit 1
''
