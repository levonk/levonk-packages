{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "pip";
  nativeCmd = "pip";
  rtkSubcommand = "pip";
  description = "compact output";
  nativePackage = pkgs.python3Packages.pip;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/pip.rtk-wrap.sh;
}