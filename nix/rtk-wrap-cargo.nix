{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "cargo";
  nativeCmd = "cargo";
  rtkSubcommand = "cargo";
  description = "compact output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/cargo.rtk-wrap.sh;
}