{ pkgs }:

pkgs.writeShellScriptBin "eslint" ''
  ${builtins.readFile ../wrappers/rtk-tools/eslint.rtk-wrap.sh}
''