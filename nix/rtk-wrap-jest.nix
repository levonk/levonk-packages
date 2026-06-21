{ pkgs }:

pkgs.writeShellScriptBin "jest" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/jest.rtk-wrap.sh}
''