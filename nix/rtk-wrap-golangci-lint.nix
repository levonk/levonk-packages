{ pkgs }:

pkgs.writeShellScriptBin "golangci-lint" ''
  ${builtins.readFile ../wrappers/rtk-tools/golangci-lint.rtk-wrap.sh}
''