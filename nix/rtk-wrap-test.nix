{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "test";
  nativeCmd = "test";
  rtkSubcommand = "test";
  description = "show only failures";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/test.rtk-wrap.sh;
}