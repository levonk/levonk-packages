{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "go";
  nativeCmd = "go";
  rtkSubcommand = "go";
  description = "compact output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/go.rtk-wrap.sh;
}