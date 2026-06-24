{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "tsc";
  nativeCmd = "tsc";
  rtkSubcommand = "tsc";
  description = "grouped error output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/tsc.rtk-wrap.sh;
}