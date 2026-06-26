{ pkgs }:

pkgs.writeShellScriptBin "bun" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/nodejs-tools/bun.prefer-nub.sh}
''
