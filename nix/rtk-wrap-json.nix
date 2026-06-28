{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "json";
  nativeCmd = "json";
  rtkSubcommand = "json";
  description = "compact values";
  rtkOnly = true;
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/json.rtk-wrap.sh;
}