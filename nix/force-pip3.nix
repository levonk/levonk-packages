{ pkgs }:

let
  pip3 = pkgs.python3;
in
pkgs.writeShellScriptBin "pip3" ''
  #!/usr/bin/env sh
  REAL_TOOL="${pip3}/bin/pip3"
  ${builtins.readFile ../wrappers/devbox-reminders/force-devbox.sh}
''
