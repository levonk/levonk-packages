{ pkgs }:

pkgs.writeShellScriptBin "wc" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/wc.rtk-wrap.sh}
''