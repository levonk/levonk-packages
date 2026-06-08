{ pkgs }:

let
  node = pkgs.nodejs;
in
pkgs.writeShellScriptBin "node" ''
  #!/usr/bin/env sh
  REAL_TOOL="${node}/bin/node"
  ${builtins.readFile ../wrappers/devbox-reminders/block-devbox.sh}
''
