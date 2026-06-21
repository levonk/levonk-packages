{ pkgs }:

pkgs.writeShellScriptBin "go" ''
  ${builtins.readFile ../wrappers/rtk-tools/go.rtk-wrap.sh}
''