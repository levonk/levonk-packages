{ pkgs }:

pkgs.writeShellScriptBin "psql" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/psql.rtk-wrap.sh}
''