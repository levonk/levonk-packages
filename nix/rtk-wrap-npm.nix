{ pkgs }:

pkgs.writeShellScriptBin "npm" ''
  ${builtins.readFile ../wrappers/rtk-tools/npm.rtk-wrap.sh}
''