{ pkgs }:

pkgs.writeShellScriptBin "eslint" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/eslint.rtk-wrap.sh}
''