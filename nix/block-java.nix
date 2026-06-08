{ pkgs }:

let
  java = pkgs.jdk;
in
pkgs.writeShellScriptBin "java" ''
  #!/usr/bin/env sh
  REAL_TOOL="${java}/bin/java"
  ${builtins.readFile ../wrappers/devbox-reminders/block-devbox.sh}
''
