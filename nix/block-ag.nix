{ pkgs }:

pkgs.writeShellScriptBin "ag" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/search-tools/ag.block-ag.sh}
''
