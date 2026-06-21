{ pkgs }:

pkgs.writeShellScriptBin "rspec" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/rspec.rtk-wrap.sh}
''