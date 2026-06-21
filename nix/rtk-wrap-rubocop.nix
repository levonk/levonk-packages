{ pkgs }:

pkgs.writeShellScriptBin "rubocop" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/rubocop.rtk-wrap.sh}
''