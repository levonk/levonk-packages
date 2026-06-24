{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "lint";
  nativeCmd = "lint";
  rtkSubcommand = "lint";
  description = "grouped rule violations";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/lint.rtk-wrap.sh;
}