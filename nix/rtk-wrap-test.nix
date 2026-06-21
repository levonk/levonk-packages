{ pkgs }:

pkgs.writeShellScriptBin "test" ''
  ${builtins.readFile ../wrappers/rtk-tools/test.rtk-wrap.sh}
''