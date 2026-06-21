{ pkgs }:

pkgs.writeShellScriptBin "gt" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/gt.rtk-wrap.sh}
''