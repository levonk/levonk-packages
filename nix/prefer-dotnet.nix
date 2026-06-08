{ pkgs }:

let
  dotnet = pkgs.dotnet-sdk;
in
pkgs.writeShellScriptBin "dotnet" ''
  #!/usr/bin/env sh
  REAL_TOOL="${dotnet}/bin/dotnet"
  ${builtins.readFile ../wrappers/devbox-reminders/prefer-dotnet.sh}
''
