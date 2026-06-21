{ pkgs }:

pkgs.writeShellScriptBin "psql" ''
  ${builtins.readFile ../wrappers/rtk-tools/psql.rtk-wrap.sh}
''