{ pkgs }:

pkgs.writeShellScriptBin "deps" ''
  ${builtins.readFile ../wrappers/rtk-tools/deps.rtk-wrap.sh}
''