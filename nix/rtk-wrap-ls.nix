{ pkgs }:

pkgs.writeShellScriptBin "ls" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/ls.rtk-wrap.sh}
''