{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "ruff";
  nativeCmd = "ruff";
  rtkSubcommand = "ruff";
  description = "compact output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/ruff.rtk-wrap.sh;
}