{ pkgs }:

pkgs.writeShellScriptBin "gradlew" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/gradlew.rtk-wrap.sh}
''