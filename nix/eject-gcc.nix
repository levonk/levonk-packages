{ pkgs }:

let
  gcc = pkgs.gcc;
in
pkgs.writeShellScriptBin "gcc" ''
  #!/usr/bin/env sh
  REAL_TOOL="${gcc}/bin/gcc"
  ${builtins.readFile ../wrappers/devbox-reminders/eject-devbox.sh}
''
