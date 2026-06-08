{ pkgs }:

let
  python3 = pkgs.python3;
in
pkgs.writeShellScriptBin "python3" ''
  #!/usr/bin/env sh
  REAL_TOOL="${python3}/bin/python3"
  ${builtins.readFile ../wrappers/devbox-reminders/block-devbox.sh}
''
