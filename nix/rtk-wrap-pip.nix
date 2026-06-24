{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "pip";
  nativeCmd = "pip";
  rtkSubcommand = "pip";
  description = "compact output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/pip.rtk-wrap.sh;
}