{ pkgs }:

let
  gem = pkgs.ruby;
in
pkgs.writeShellScriptBin "gem" ''
  #!/usr/bin/env sh
  REAL_TOOL="${gem}/bin/gem"
  ${builtins.readFile ../wrappers/devbox-reminders/force-devbox.sh}
''
