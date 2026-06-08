{ pkgs }:

let
  gpp = pkgs.gcc;
in
pkgs.writeShellScriptBin "g++" ''
  #!/usr/bin/env sh
  REAL_TOOL="${gpp}/bin/g++"
  ${builtins.readFile ../wrappers/devbox-reminders/prefer-gpp.sh}
''
