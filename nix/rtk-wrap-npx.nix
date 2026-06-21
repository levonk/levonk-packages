{ pkgs }:

pkgs.writeShellScriptBin "npx" ''
  ${builtins.readFile ../wrappers/rtk-tools/npx.rtk-wrap.sh}
''