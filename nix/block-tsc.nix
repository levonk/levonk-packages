{ pkgs }:

let
  tsc = pkgs.typescript;
in
pkgs.writeShellScriptBin "tsc" ''
  #!/usr/bin/env sh
  REAL_TOOL="${tsc}/bin/tsc"
  ${builtins.readFile ../wrappers/devbox-reminders/block-devbox.sh}
''
