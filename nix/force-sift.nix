{ pkgs }:

pkgs.writeShellScriptBin "sift" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/search-tools/sift.force-sift.sh}
''
