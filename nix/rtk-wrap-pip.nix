{ pkgs }:

pkgs.writeShellScriptBin "pip" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/pip.rtk-wrap.sh}
''