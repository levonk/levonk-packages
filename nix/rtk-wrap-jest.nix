{ pkgs }:

pkgs.writeShellScriptBin "jest" ''
  ${builtins.readFile ../wrappers/rtk-tools/jest.rtk-wrap.sh}
''