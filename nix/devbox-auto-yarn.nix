{ pkgs }:

pkgs.writeShellScriptBin "yarn" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/devbox-auto-tools/yarn.devbox-auto.sh}
''