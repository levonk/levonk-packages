{ pkgs }:

pkgs.writeShellScriptBin "gt" ''
  ${builtins.readFile ../wrappers/rtk-tools/gt.rtk-wrap.sh}
''