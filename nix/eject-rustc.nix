{ pkgs }:

let
  rustc = pkgs.rustc;
in
pkgs.writeShellScriptBin "rustc" ''
  #!/usr/bin/env sh
  REAL_TOOL="${rustc}/bin/rustc"
  ${builtins.readFile ../wrappers/devbox-reminders/eject-devbox.sh}
''
