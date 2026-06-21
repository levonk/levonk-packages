{ pkgs }:

pkgs.writeShellScriptBin "curl" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/curl.rtk-wrap.sh}
''