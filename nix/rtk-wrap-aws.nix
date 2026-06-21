{ pkgs }:

pkgs.writeShellScriptBin "aws" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/aws.rtk-wrap.sh}
''