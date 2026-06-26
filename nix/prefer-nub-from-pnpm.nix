{ pkgs }:

pkgs.writeShellScriptBin "pnpm" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/nodejs-tools/pnpm.prefer-nub.sh}
''
