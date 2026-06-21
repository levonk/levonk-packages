{ pkgs }:

pkgs.writeShellScriptBin "wget" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/wget.rtk-wrap.sh}
''