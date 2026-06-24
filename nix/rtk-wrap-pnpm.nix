{ pkgs }:

import ./lib/rtk-wrap-lib.nix { inherit pkgs; } {
  name = "pnpm";
  nativeCmd = "pnpm";
  rtkSubcommand = "pnpm";
  description = "ultra-compact output";
  wrapperContent = builtins.readFile ../wrappers/rtk-tools/pnpm.rtk-wrap.sh;
}