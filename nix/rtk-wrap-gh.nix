{ pkgs }:

pkgs.writeShellScriptBin "gh" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/gh.rtk-wrap.sh}
''