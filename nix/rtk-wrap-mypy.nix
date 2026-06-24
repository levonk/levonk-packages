{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "mypy";
  nativeCmd = "mypy";
  rtkSubcommand = "mypy";
  description = "grouped error output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/mypy.rtk-wrap.sh;
}