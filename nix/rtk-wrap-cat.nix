{ pkgs }:

pkgs.writeShellScriptBin "cat" ''
  ${builtins.readFile ../wrappers/rtk-tools/cat.rtk-wrap.sh}
''