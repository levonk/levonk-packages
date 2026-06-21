{ pkgs }:

pkgs.writeShellScriptBin "ls" ''
  ${builtins.readFile ../wrappers/rtk-tools/ls.rtk-wrap.sh}
''