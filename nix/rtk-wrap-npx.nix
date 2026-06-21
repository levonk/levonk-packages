{ pkgs }:

pkgs.writeShellScriptBin "npx" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/npx.rtk-wrap.sh}
''