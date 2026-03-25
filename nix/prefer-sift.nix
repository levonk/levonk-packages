{ pkgs }:

pkgs.writeShellScriptBin "sift" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/sift.prefer-ripgrep.sh}
''
