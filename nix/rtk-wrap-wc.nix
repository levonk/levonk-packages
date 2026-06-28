{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "wc";
  nativeCmd = "wc";
  rtkSubcommand = "wc";
  description = "compact output";
  nativePackage = pkgs.coreutils;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/wc.rtk-wrap.sh;
}