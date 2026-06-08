{ pkgs }:

let
  just = pkgs.just;
in
pkgs.writeShellScriptBin "just" ''
  #!/usr/bin/env sh
  REAL_TOOL="${just}/bin/just"
  ${builtins.readFile ../wrappers/devbox-reminders/force-devbox.sh}
''
