{ pkgs }:

pkgs.writeShellScriptBin "env" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/env.rtk-wrap.sh}
''