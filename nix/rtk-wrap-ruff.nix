{ pkgs }:

pkgs.writeShellScriptBin "ruff" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/ruff.rtk-wrap.sh}
''