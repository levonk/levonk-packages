{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "rspec";
  nativeCmd = "rspec";
  rtkSubcommand = "rspec";
  description = "compact JSON output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/rspec.rtk-wrap.sh;
}