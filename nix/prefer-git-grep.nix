{ pkgs }:

pkgs.writeShellScriptBin "git-grep" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/git-grep.prefer-ripgrep.sh}
''
