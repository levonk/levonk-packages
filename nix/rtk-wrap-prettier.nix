{ pkgs }:

pkgs.writeShellScriptBin "prettier" ''
  ${builtins.readFile ../wrappers/rtk-tools/prettier.rtk-wrap.sh}
''