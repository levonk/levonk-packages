{ pkgs }:

let
  make = pkgs.gnumake;
in
pkgs.writeShellScriptBin "make" ''
  #!/usr/bin/env sh
  REAL_TOOL="${make}/bin/make"
  ${builtins.readFile ../wrappers/devbox-reminders/force-devbox.sh}
''
