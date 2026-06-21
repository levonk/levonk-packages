{ pkgs }:

pkgs.writeShellScriptBin "err" ''
  ${builtins.readFile ../wrappers/rtk-tools/err.rtk-wrap.sh}
''