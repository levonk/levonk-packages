{ pkgs }:

pkgs.writeShellScriptBin "dotnet" ''
  ${builtins.readFile ../wrappers/rtk-tools/dotnet.rtk-wrap.sh}
''