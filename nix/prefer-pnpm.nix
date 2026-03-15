{ pkgs }:

pkgs.writeShellScriptBin "npm" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/npm.prefer-pnpm.sh}
''
