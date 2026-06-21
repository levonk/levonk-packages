{ pkgs }:

pkgs.writeShellScriptBin "prettier" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/prettier.rtk-wrap.sh}
''