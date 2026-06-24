{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "format";
  nativeCmd = "format";
  rtkSubcommand = "format";
  description = "universal format checker";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/format.rtk-wrap.sh;
}