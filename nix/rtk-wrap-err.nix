{ pkgs }:

pkgs.writeShellScriptBin "err" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/err.rtk-wrap.sh}
''