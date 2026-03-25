{ pkgs }:

pkgs.writeShellScriptBin "pt" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/pt.prefer-ripgrep.sh}
''
