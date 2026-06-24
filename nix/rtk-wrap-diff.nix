{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "diff";
  nativeCmd = "diff";
  rtkSubcommand = "diff";
  description = "ultra-condensed output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/diff.rtk-wrap.sh;
}