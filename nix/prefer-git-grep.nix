{ pkgs }:

pkgs.writeShellScriptBin "git-grep" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/search-tools/git-grep.prefer-ripgrep.sh}
''
