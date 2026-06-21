{ pkgs }:

pkgs.writeShellScriptBin "python" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/devbox-auto-tools/python.devbox-auto.sh}
''