{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "glab";
  nativeCmd = "glab";
  rtkSubcommand = "glab";
  description = "token-optimized output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/glab.rtk-wrap.sh;
}