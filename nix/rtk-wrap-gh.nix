{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "gh";
  nativeCmd = "gh";
  rtkSubcommand = "gh";
  description = "token-optimized output";
  nativePackage = pkgs.gh;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/gh.rtk-wrap.sh;
}