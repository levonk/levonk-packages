{ pkgs }:

pkgs.writeShellScriptBin "rustc" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/devbox-auto-tools/rustc.devbox-auto.sh}
''