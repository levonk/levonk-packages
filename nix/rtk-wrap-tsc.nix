{ pkgs }:

pkgs.writeShellScriptBin "tsc" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/tsc.rtk-wrap.sh}
''