{ pkgs }:

let
  pip = pkgs.python3;
in
pkgs.writeShellScriptBin "pip" ''
  #!/usr/bin/env sh
  REAL_TOOL="${pip}/bin/pip"
  ${builtins.readFile ../wrappers/devbox-reminders/force-devbox.sh}
''
