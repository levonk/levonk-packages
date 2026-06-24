{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "rake";
  nativeCmd = "rake";
  rtkSubcommand = "rake";
  description = "compact minitest output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/rake.rtk-wrap.sh;
}