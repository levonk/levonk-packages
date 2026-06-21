{ pkgs }:

pkgs.writeShellScriptBin "wc" ''
  ${builtins.readFile ../wrappers/rtk-tools/wc.rtk-wrap.sh}
''