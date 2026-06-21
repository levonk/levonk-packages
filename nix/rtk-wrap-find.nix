{ pkgs }:

pkgs.writeShellScriptBin "find" ''
  ${builtins.readFile ../wrappers/rtk-tools/find.rtk-wrap.sh}
''