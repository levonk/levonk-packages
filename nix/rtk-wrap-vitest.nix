{ pkgs }:

pkgs.writeShellScriptBin "vitest" ''
  ${builtins.readFile ../wrappers/rtk-tools/vitest.rtk-wrap.sh}
''