{ pkgs }:

pkgs.writeShellScriptBin "prisma" ''
  ${builtins.readFile ../wrappers/rtk-tools/prisma.rtk-wrap.sh}
''