{ pkgs }:

pkgs.writeShellScriptBin "dotnet" ''
  #!/usr/bin/env sh
  ${builtins.readFile ../wrappers/rtk-tools/dotnet.rtk-wrap.sh}
''