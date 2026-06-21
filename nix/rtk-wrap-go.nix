{ pkgs }:

pkgs.writeShellScriptBin "go" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/go.rtk-wrap.sh}
''