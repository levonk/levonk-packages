{ pkgs }:

pkgs.writeShellScriptBin "rubocop" ''
  ${builtins.readFile ../wrappers/rtk-tools/rubocop.rtk-wrap.sh}
''