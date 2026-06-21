{ pkgs }:

pkgs.writeShellScriptBin "prisma" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/prisma.rtk-wrap.sh}
''