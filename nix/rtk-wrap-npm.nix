{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "npm";
  nativeCmd = "npm";
  rtkSubcommand = "npm";
  description = "filtered output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/npm.rtk-wrap.sh;
}