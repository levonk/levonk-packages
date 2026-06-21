{ pkgs }:

pkgs.writeShellScriptBin "format" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/format.rtk-wrap.sh}
''