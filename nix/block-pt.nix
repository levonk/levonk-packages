{ pkgs }:

pkgs.writeShellScriptBin "pt" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/pt.block-pt.sh}
''
