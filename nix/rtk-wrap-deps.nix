{ pkgs }:

pkgs.writeShellScriptBin "deps" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/deps.rtk-wrap.sh}
''