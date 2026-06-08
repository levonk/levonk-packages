{ pkgs }:

let
  javac = pkgs.jdk;
in
pkgs.writeShellScriptBin "javac" ''
  #!/usr/bin/env sh
  REAL_TOOL="${javac}/bin/javac"
  ${builtins.readFile ../wrappers/devbox-reminders/force-devbox.sh}
''
