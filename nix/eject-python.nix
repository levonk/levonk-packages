{ pkgs }:

let
  python = pkgs.python3;
in
pkgs.writeShellScriptBin "python" ''
  #!/usr/bin/env sh
  REAL_TOOL="${python}/bin/python"
  ${builtins.readFile ../wrappers/devbox-reminders/eject-devbox.sh}
''
