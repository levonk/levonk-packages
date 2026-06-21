{ pkgs }:

pkgs.writeShellScriptBin "glab" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/glab.rtk-wrap.sh}
''