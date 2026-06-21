{ pkgs }:

pkgs.writeShellScriptBin "pip" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/devbox-auto-tools/pip.devbox-auto.sh}
''