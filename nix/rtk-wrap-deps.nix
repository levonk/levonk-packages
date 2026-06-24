{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "deps";
  nativeCmd = "deps";
  rtkSubcommand = "deps";
  description = "summarize project dependencies";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/deps.rtk-wrap.sh;
}