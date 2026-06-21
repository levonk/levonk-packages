{ pkgs }:

pkgs.writeShellScriptBin "diff" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/diff.rtk-wrap.sh}
''