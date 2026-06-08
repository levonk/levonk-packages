{ pkgs }:

let
  ninja = pkgs.ninja;
in
pkgs.writeShellScriptBin "ninja" ''
  #!/usr/bin/env sh
  REAL_TOOL="${ninja}/bin/ninja"
  ${builtins.readFile ../wrappers/devbox-reminders/prefer-ninja.sh}
''
