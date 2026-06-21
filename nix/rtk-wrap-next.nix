{ pkgs }:

pkgs.writeShellScriptBin "next" ''
  ${builtins.readFile ../wrappers/rtk-tools/next.rtk-wrap.sh}
''