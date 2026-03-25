{ pkgs }:

pkgs.writeShellScriptBin "grep" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/grep.eject-grep.sh}
''
