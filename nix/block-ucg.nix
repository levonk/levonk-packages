{ pkgs }:

pkgs.writeShellScriptBin "ucg" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/search-tools/ucg.block-ucg.sh}
''
