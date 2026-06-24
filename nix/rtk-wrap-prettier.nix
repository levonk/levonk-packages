{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "prettier";
  nativeCmd = "prettier";
  rtkSubcommand = "prettier";
  description = "compact output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/prettier.rtk-wrap.sh;
}