{ pkgs }:

let
  go = pkgs.go;
in
pkgs.writeShellScriptBin "go" ''
  #!/usr/bin/env sh
  REAL_TOOL="${go}/bin/go"
  ${builtins.readFile ../wrappers/devbox-reminders/force-devbox.sh}
''
