{ pkgs }:

pkgs.writeShellScriptBin "npm" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/nodejs-tools/npm.prefer-nub.sh}
''
