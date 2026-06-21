{ pkgs }:

pkgs.writeShellScriptBin "oc" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/oc.rtk-wrap.sh}
''