{ pkgs }:

pkgs.writeShellScriptBin "npm" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/npm.rtk-wrap.sh}
''