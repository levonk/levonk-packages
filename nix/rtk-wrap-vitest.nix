{ pkgs }:

pkgs.writeShellScriptBin "vitest" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/vitest.rtk-wrap.sh}
''