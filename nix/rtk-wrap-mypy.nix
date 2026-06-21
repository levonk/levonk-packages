{ pkgs }:

pkgs.writeShellScriptBin "mypy" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/mypy.rtk-wrap.sh}
''