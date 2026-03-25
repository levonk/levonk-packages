{ pkgs }:

pkgs.writeShellScriptBin "grep" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/search-tools/grep.eject-grep.sh}
''
