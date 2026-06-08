{ pkgs }:

let
  uv = pkgs.uv;
in
pkgs.writeShellScriptBin "uv" ''
  #!/usr/bin/env sh
  REAL_TOOL="${uv}/bin/uv"
  ${builtins.readFile ../wrappers/devbox-reminders/eject-devbox.sh}
''
