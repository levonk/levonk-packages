{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "dotnet";
  nativeCmd = "dotnet";
  rtkSubcommand = "dotnet";
  description = "compact output";
  nativePackage = pkgs.dotnet-sdk;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/dotnet.rtk-wrap.sh;
}