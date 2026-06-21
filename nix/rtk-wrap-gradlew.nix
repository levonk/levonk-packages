{ pkgs }:

pkgs.writeShellScriptBin "gradlew" ''
  ${builtins.readFile ../wrappers/rtk-tools/gradlew.rtk-wrap.sh}
''