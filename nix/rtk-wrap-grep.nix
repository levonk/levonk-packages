{ pkgs }:

pkgs.writeShellScriptBin "grep" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/grep.rtk-wrap.sh}
''