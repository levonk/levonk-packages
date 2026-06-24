{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "find";
  nativeCmd = "find";
  rtkSubcommand = "find";
  description = "compact tree output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/find.rtk-wrap.sh;
}