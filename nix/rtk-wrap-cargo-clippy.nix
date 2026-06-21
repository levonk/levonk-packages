{ pkgs }:

pkgs.writeShellScriptBin "cargo-clippy" ''
  ${builtins.readFile ../wrappers/rtk-tools/cargo-clippy.rtk-wrap.sh}
''