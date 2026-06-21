{ pkgs }:

pkgs.writeShellScriptBin "find" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/find.rtk-wrap.sh}
''