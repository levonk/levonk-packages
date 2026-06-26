{ pkgs }:

pkgs.writeShellScriptBin "yarn" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/nodejs-tools/yarn.prefer-nub.sh}
''
