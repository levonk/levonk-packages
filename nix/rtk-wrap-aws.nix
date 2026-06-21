{ pkgs }:

pkgs.writeShellScriptBin "aws" ''
  ${builtins.readFile ../wrappers/rtk-tools/aws.rtk-wrap.sh}
''