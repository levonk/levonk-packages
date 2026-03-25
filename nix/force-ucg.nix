{ pkgs }:

pkgs.writeShellScriptBin "ucg" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/search-tools/ucg.force-ucg.sh}
''
