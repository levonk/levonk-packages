{ pkgs }:

pkgs.writeShellScriptBin "cargo" ''
  ${builtins.readFile ../wrappers/rtk-tools/cargo.rtk-wrap.sh}
''