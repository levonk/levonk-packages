{ pkgs }:

let
  cmake = pkgs.cmake;
in
pkgs.writeShellScriptBin "cmake" ''
  #!/usr/bin/env sh
  REAL_TOOL="${cmake}/bin/cmake"
  ${builtins.readFile ../wrappers/devbox-reminders/prefer-cmake.sh}
''
