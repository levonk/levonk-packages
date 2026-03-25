{ pkgs }:

pkgs.writeShellScriptBin "ag" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/ag.block-ag.sh}
''
