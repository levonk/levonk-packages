{ pkgs }:

pkgs.writeShellScriptBin "ucg" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/search-tools/ucg.prefer-ripgrep.sh}
''
