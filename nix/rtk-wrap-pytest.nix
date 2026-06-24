{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "pytest";
  nativeCmd = "pytest";
  rtkSubcommand = "pytest";
  description = "compact output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/pytest.rtk-wrap.sh;
}