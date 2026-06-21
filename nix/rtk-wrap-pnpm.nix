{ pkgs }:

pkgs.writeShellScriptBin "pnpm" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/pnpm.rtk-wrap.sh}
''