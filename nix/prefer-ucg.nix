{ pkgs }:

pkgs.writeShellScriptBin "ucg" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/ucg.prefer-ripgrep.sh}
''
