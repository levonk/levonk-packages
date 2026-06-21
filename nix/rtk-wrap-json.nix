{ pkgs }:

pkgs.writeShellScriptBin "json" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/json.rtk-wrap.sh}
''