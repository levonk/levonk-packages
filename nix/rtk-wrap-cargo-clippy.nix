{ pkgs }:

pkgs.writeShellScriptBin "cargo-clippy" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/cargo-clippy.rtk-wrap.sh}
''