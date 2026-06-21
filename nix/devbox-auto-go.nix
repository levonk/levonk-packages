{ pkgs }:

pkgs.writeShellScriptBin "go" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/devbox-auto-tools/go.devbox-auto.sh}
''