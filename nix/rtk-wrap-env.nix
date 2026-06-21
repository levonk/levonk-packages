{ pkgs }:

pkgs.writeShellScriptBin "env" ''
  ${builtins.readFile ../wrappers/rtk-tools/env.rtk-wrap.sh}
''