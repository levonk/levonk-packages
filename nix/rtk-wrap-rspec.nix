{ pkgs }:

pkgs.writeShellScriptBin "rspec" ''
  ${builtins.readFile ../wrappers/rtk-tools/rspec.rtk-wrap.sh}
''