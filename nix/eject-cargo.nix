{ pkgs }:

let
  cargo = pkgs.cargo;
in
pkgs.writeShellScriptBin "cargo" ''
  #!/usr/bin/env sh
  REAL_TOOL="${cargo}/bin/cargo"
  ${builtins.readFile ../wrappers/devbox-reminders/eject-devbox.sh}
''
