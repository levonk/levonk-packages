{ pkgs }:

pkgs.writeShellScriptBin "cargo" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/cargo.rtk-wrap.sh}
''