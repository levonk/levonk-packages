{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "gt";
  nativeCmd = "gt";
  rtkSubcommand = "gt";
  description = "compact stacked PR output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/gt.rtk-wrap.sh;
}