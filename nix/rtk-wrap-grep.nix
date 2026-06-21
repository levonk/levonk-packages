{ pkgs }:

pkgs.writeShellScriptBin "grep" ''
  ${builtins.readFile ../wrappers/rtk-tools/grep.rtk-wrap.sh}
''