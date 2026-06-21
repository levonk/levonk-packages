{ pkgs }:

pkgs.writeShellScriptBin "tree" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/tree.rtk-wrap.sh}
''