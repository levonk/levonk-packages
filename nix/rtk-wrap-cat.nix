{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "cat";
  nativeCmd = "cat";
  rtkSubcommand = "read";
  description = "intelligent file filtering";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/cat.rtk-wrap.sh;
}