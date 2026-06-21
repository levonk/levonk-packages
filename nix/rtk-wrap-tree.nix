{ pkgs }:

pkgs.writeShellScriptBin "tree" ''
  ${builtins.readFile ../wrappers/rtk-tools/tree.rtk-wrap.sh}
''