{ pkgs }:

let
  clang = pkgs.clang;
in
pkgs.writeShellScriptBin "clang" ''
  #!/usr/bin/env sh
  REAL_TOOL="${clang}/bin/clang"
  ${builtins.readFile ../wrappers/devbox-reminders/force-devbox.sh}
''
