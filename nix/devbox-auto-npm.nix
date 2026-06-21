{ pkgs }:

pkgs.writeShellScriptBin "npm" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/devbox-auto-tools/npm.devbox-auto.sh}
''