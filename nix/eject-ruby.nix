{ pkgs }:

let
  ruby = pkgs.ruby;
in
pkgs.writeShellScriptBin "ruby" ''
  #!/usr/bin/env sh
  REAL_TOOL="${ruby}/bin/ruby"
  ${builtins.readFile ../wrappers/devbox-reminders/eject-devbox.sh}
''
