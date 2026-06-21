{ pkgs }:

pkgs.writeShellScriptBin "golangci-lint" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/golangci-lint.rtk-wrap.sh}
''