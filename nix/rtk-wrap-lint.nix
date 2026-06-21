{ pkgs }:

pkgs.writeShellScriptBin "lint" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/lint.rtk-wrap.sh}
''