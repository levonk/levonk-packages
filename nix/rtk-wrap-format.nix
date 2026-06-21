{ pkgs }:

pkgs.writeShellScriptBin "format" ''
  ${builtins.readFile ../wrappers/rtk-tools/format.rtk-wrap.sh}
''