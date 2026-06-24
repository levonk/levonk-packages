{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "npx";
  nativeCmd = "npx";
  rtkSubcommand = "npx";
  description = "intelligent routing";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/npx.rtk-wrap.sh;
}