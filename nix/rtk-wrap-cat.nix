{ pkgs }:

pkgs.writeShellScriptBin "cat" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/cat.rtk-wrap.sh}
''