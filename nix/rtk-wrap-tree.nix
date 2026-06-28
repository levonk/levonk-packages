{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "tree";
  nativeCmd = "tree";
  rtkSubcommand = "tree";
  description = "token-optimized output";
  nativePackage = pkgs.tree;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/tree.rtk-wrap.sh;
}