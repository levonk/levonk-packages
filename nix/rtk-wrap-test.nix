{ pkgs }:

pkgs.writeShellScriptBin "test" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/test.rtk-wrap.sh}
''