{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "next";
  nativeCmd = "next";
  rtkSubcommand = "next";
  description = "compact build output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/next.rtk-wrap.sh;
}