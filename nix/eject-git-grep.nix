{ pkgs }:

pkgs.writeShellScriptBin "git-grep" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/git-grep.eject-git-grep.sh}
''
