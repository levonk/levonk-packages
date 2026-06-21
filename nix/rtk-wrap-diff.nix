{ pkgs }:

pkgs.writeShellScriptBin "diff" ''
  ${builtins.readFile ../wrappers/rtk-tools/diff.rtk-wrap.sh}
''