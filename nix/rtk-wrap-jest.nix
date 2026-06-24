{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "jest";
  nativeCmd = "jest";
  rtkSubcommand = "jest";
  description = "compact output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/jest.rtk-wrap.sh;
}