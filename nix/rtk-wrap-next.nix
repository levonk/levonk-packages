{ pkgs }:

pkgs.writeShellScriptBin "next" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/next.rtk-wrap.sh}
''