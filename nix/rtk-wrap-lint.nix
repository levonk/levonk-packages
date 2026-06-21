{ pkgs }:

pkgs.writeShellScriptBin "lint" ''
  ${builtins.readFile ../wrappers/rtk-tools/lint.rtk-wrap.sh}
''