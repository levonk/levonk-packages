{ pkgs }:

pkgs.writeShellScriptBin "cargo" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/devbox-auto-tools/cargo.devbox-auto.sh}
''