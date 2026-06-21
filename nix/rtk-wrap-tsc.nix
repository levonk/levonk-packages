{ pkgs }:

pkgs.writeShellScriptBin "tsc" ''
  ${builtins.readFile ../wrappers/rtk-tools/tsc.rtk-wrap.sh}
''