{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "eslint";
  nativeCmd = "eslint";
  rtkSubcommand = "eslint";
  description = "grouped rule violations";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/eslint.rtk-wrap.sh;
}